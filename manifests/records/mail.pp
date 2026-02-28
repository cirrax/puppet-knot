# @summary add mail dns records to the domain
# 
# used to add a common set of dns records to a domain 
# for a mail service. This includes records for automated
# client configuration (autoconfig, autodiscover, SRV records)
# and setup up SPV, DKIM, DMARC etc used for server to server
# communication.
# 
# default values can be configured in the class
# knot::records::defaults::webserver which is included
# here (eg in hiera).
#
# @param rname
#  the hostname to add
# @param target_zone
#  the target zone to add the records
# @param mailserver
#  target mailservers for mx record
# @param ttl
#  the time to live (used for all records)
#  default from knot::records::defaults::webserver
# @param autodiscover
#  if set, adds a SRV record for autodiscover
#  used by Microsoft clients
#  Example:
#  { 'weight' => 0, 
#    'priority' => 10,
#    'target_port' => 443,
#    'target' => 'autodiscover.hostname.com'
#  } 
#  default from knot::records::defaults::mail
# @param autoconfig
#  target to config for autconfig (eg. Thunderbird)
#  a CNAME record is created
# @param submission
#  if set, adds a SRV record for submission (format see
#  autodiscover example above).
#  default from knot::records::defaults::mail
# @param imaps
#  if set, adds a SRV record for imaps (format see
#  autodiscover example above).
#  default from knot::records::defaults::mail
# @param pop3s 
#  if set, adds a SRV record for pop3s (format see
#  autodiscover example above).
#  default from knot::records::defaults::mail
# @param caa
#  caa records to create (using define knot::records::caa)
#  default from knot::records::defaults::mail
# @param spf_rtypes
#  resource types to create for spf record
# @param spf
#  SPF record to add 
#  (see https://datatracker.ietf.org/doc/html/rfc7208)
#  default from knot::records::defaults::mail
# @param dkim_keys
#  hash of dkim keys
# @param dkim_policy
#  dkim policy (TXT record _domainkey)
#  see https://datatracker.ietf.org/doc/html/rfc4870
#  and https://datatracker.ietf.org/doc/html/rfc4871
# @param adsp_policy
#  adsp policy (TXT record _adsp._domainkey)
#  see https://datatracker.ietf.org/doc/html/rfc5617
# @param dmarc_policy
#  dmarc policy (TXT record _dmarc)
#  see https://datatracker.ietf.org/doc/html/rfc7489
#  see https://www.learndmarc.comt/
# @param dmarc_authorization
#  dmarc authorization TXT record
#  if dmarc reports go to another domain, the other domains
#  needs a record to authorize such reports.
#  so this record is generated in the report receiving domain, which
#  only works if this domain is also setup with knot and enabled to
#  receive puppet generated records (if the target domain is not
#  setup for receiving the generated authorization, the setting is
#  silently ignored !)
#  record is: ${target_zone}._report._dmarc TXT ${dmarch_authorization}
#  see https://datatracker.ietf.org/doc/html/rfc7489 (section 7.1)
#  see https://dmarc.org/2015/08/receiving-dmarc-reports-outside-your-domain
#
define knot::records::mail (
  Optional[String[1]]                        $rname               = undef,
  Optional[String[1]]                        $target_zone         = undef,
  Optional[Array[Knot::Record::Mx]]          $mailserver          = undef,
  Optional[Integer]                          $ttl                 = undef,
  Optional[Array[Knot::Record::Srv]]         $autodiscover        = undef,
  Optional[String[1]]                        $autoconfig          = undef,
  Optional[Array[Knot::Record::Srv]]         $submission          = undef,
  Optional[Array[Knot::Record::Srv]]         $imaps               = undef,
  Optional[Array[Knot::Record::Srv]]         $pop3s               = undef,
  Optional[Array[Knot::Record::Caa]]         $caa                 = undef,
  Array[Enum['SPF','TXT']]                   $spf_rtypes          = ['SPF','TXT'],
  Optional[Knot::Record::Spf]                $spf                 = undef,
  Optional[Hash[String[1],Array[String[1]]]] $dkim_keys           = undef,
  Optional[String[1]]                        $dkim_policy         = undef,
  Optional[String[1]]                        $adsp_policy         = undef,
  Optional[Array[String[1]]]                 $dmarc_policy        = undef,
  Optional[Knot::Record::Dmarc_auth]         $dmarc_authorization = undef,
) {
  $_target_zone = pick($target_zone, knot::zone($title))
  $_rname       = pick($rname, knot::hname($title))

  include knot::records::defaults::mail

  $_mailserver = pick($mailserver, $knot::records::defaults::mail::mailserver)
  $_caa = pick($caa, $knot::records::defaults::mail::caa)
  $_submission = pick($submission, $knot::records::defaults::mail::submission)
  $_imaps = pick($imaps, $knot::records::defaults::mail::imaps)
  $_pop3s = pick($pop3s, $knot::records::defaults::mail::pop3s)
  $_autodiscover = pick($autodiscover, $knot::records::defaults::mail::autodiscover)
  $_autoconfig = pick($autoconfig, $knot::records::defaults::mail::autoconfig, false)
  $_spf = pick($spf, $knot::records::defaults::mail::spf, false)
  $_dkim_keys = pick($dkim_keys, $knot::records::defaults::mail::dkim_keys)
  $_dkim_policy = pick($dkim_policy, $knot::records::defaults::mail::dkim_policy, false)
  $_adsp_policy = pick($adsp_policy, $knot::records::defaults::mail::adsp_policy, false)
  $_dmarc_policy = pick($dmarc_policy, $knot::records::defaults::mail::dmarc_policy, false)
  $_dmarc_authorization = pick($dmarc_authorization, $knot::records::defaults::mail::dmarc_authorization, false)

  $_ttl = pick($ttl, $knot::records::defaults::mail::ttl)

  $_mailserver.each | Integer $i, Knot::Record::Mx $v | {
    knot_record { "mail MX: ${title} (${i})":
      target_zone => $_target_zone,
      rname       => $_rname,
      rttl        => $_ttl,
      rtype       => 'MX',
      rcontent    => "${v['prio']} ${v['target']}",
    }
  }

  if $_spf {
    $spf_rtypes.each | String[1] $sr | {
      knot_record { "spf (${sr}): ${title}":
        target_zone => $_target_zone,
        rname       => $_rname,
        rttl        => $_ttl,
        rtype       => $sr,
        rcontent    => ['"', ["v=${$_spf['version']}", $_spf['mechanism'], $_spf['modifier']].join(' '),'"'].join(''),
      }
    }
  }

  if $_autoconfig {
    knot_record { "autoconfig: ${title}":
      target_zone => $_target_zone,
      rname       => 'autoconfig',
      rttl        => $_ttl,
      rtype       => 'CNAME',
      rcontent    => $_autoconfig,
    }
  }

  knot::records::caa { "mail CAA ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    caa         => $_caa,
  }

  knot::records::srv { "autodiscover ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    srv         => $_autodiscover,
    service     => [{ 'port' => 'autodiscover', 'proto' => 'tcp' }],
  }

  knot::records::srv { "submission ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    srv         => $_submission,
    service     => [{ 'port' => 'submission', 'proto' => 'tcp' }],
  }

  knot::records::srv { "imaps ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    srv         => $_imaps,
    service     => [{ 'port' => 'imaps', 'proto' => 'tcp' }],
  }

  knot::records::srv { "pop3s ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    srv         => $_pop3s,
    service     => [{ 'port' => 'pop3s', 'proto' => 'tcp' }],
  }

  $_dkim_keys.each | String[1] $k, Array[String[1]] $v | {
    knot_record { "dkim key ${k} for ${title}":
      target_zone => $_target_zone,
      rname       => "${k}._domainkey",
      rttl        => $_ttl,
      rtype       => 'TXT',
      rcontent    => ['"', $v.join('; '), '"'].join(),
    }
  }

  if $_dkim_policy {
    knot_record { "dkim policy: ${title}":
      target_zone => $_target_zone,
      rname       => '_domainkey',
      rttl        => $_ttl,
      rtype       => 'TXT',
      rcontent    => "\"${_dkim_policy}\"",
    }
  }

  if $_adsp_policy {
    knot_record { "adsp policy: ${title}":
      target_zone => $_target_zone,
      rname       => '_adsp._domainkey',
      rttl        => $_ttl,
      rtype       => 'TXT',
      rcontent    => "\"${_adsp_policy}\"",
    }
  }
  if $_dmarc_policy {
    knot_record { "dmarc policy: ${title}":
      target_zone => $_target_zone,
      rname       => '_dmarc',
      rttl        => $_ttl,
      rtype       => 'TXT',
      rcontent    => ['"', $_dmarc_policy.join(';'), '"'].join(),
    }
  }
  if $_dmarc_authorization {
    knot_record { "dmarc authorization: ${title}":
      target_zone => $_dmarc_authorization['target_zone'],
      rname       => "${_target_zone}._report._dmarc",
      rttl        => $_ttl,
      rtype       => 'TXT',
      rcontent    => "\"${_dmarc_authorization['record']}\"",
    }
  }
}
