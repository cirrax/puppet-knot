# @summary default values for knot::records::mail
# 
# this class add the defaults used in knot::records::mail
# for adding the records.
#
# @param mailserver
#  target mailservers for mx record
# @param ttl
#  the time to live (used for all records)
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
# @param imaps
#  if set, adds a SRV record for imaps (format see
#  autodiscover example above).
# @param pop3s 
#  if set, adds a SRV record for pop3s (format see
#  autodiscover example above).
# @param caa
#  caa records to create (using define knot::records::caa)
# @param spf
#  SPF record to add 
#  (see https://datatracker.ietf.org/doc/html/rfc7208)
# @param dkim_keys
#  Hash of dkim keys
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
# @param dmarc_authorization
#  dmarc authorization TXT record
#  if dmarc reports go to another domain, the other domains
#  needs a record to authorize such reports.
#  so this record is generated in the report receiving domain, which
#  only works if this domain is also setup with knot and enabled to
#  receive puppet generated records.
#  record is: ${target_zone}._report._dmarc TXT ${dmarch_authorization}
#  see https://datatracker.ietf.org/doc/html/rfc7489 (section 7.1)
#  see https://dmarc.org/2015/08/receiving-dmarc-reports-outside-your-domain
#  
class knot::records::defaults::mail (
  Array[Knot::Record::Mx]            $mailserver          = [],
  Integer                            $ttl                 = 3600,
  Array[Knot::Record::Srv]           $autodiscover        = [],
  Optional[String[1]]                $autoconfig          = undef,
  Array[Knot::Record::Srv]           $submission          = [],
  Array[Knot::Record::Srv]           $imaps               = [],
  Array[Knot::Record::Srv]           $pop3s               = [],
  Array[Knot::Record::Caa]           $caa                 = [],
  Optional[Knot::Record::Spf]        $spf                 = undef,
  Hash[String[1],Array[String[1]]]   $dkim_keys           = {},
  Optional[String[1]]                $dkim_policy         = undef,
  Optional[String[1]]                $adsp_policy         = undef,
  Optional[Array[String[1]]]         $dmarc_policy        = undef,
  Optional[Knot::Record::Dmarc_auth] $dmarc_authorization = undef,
) {
}
