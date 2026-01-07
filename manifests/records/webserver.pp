# @summary add webserver dns records to the domain
# 
# used to add a common set of dns records to a domain 
# for a webserver.
# 
# default values can be configured in the class
# knot::records::defaults::webserver which is included
# here (eg in hiera).
#
# @param rname
#  the hostname to add
# @param target_zone
#  the target zone to add the records
# @param ipv4
#  the ipv4 address (A record)
#  default from knot::records::defaults::webserver
# @param ipv6
#  the ipv4 address (AAAA record)
#  default from knot::records::defaults::webserver
# @param alpn
#  the ALPN record(s)
#  default from knot::records::defaults::webserver
# @param ttl
#  the time to live (used for all records)
#  default from knot::records::defaults::webserver
# @param caa
#  caa records to create (using define knot::records::caa)
#  default from knot::records::defaults::webserver
# @param tlsa
#  tlsa records to create (using define knot::records::tlsa)
#  default from knot::records::defaults::webserver
# @param tlsa_service
#  tlsa services to create tlsa records for (using define knot::records::tlsa)
#  default from knot::records::defaults::webserver
#
define knot::records::webserver (
  Optional[String[1]]                         $rname        = undef,
  Optional[String[1]]                         $target_zone  = undef,
  Optional[Stdlib::IP::Address::V4::Nosubnet] $ipv4         = undef,
  Optional[Stdlib::IP::Address::V6::Nosubnet] $ipv6         = undef,
  Optional[Array[String[1]]]                  $alpn         = undef,
  Optional[Integer]                           $ttl          = undef,
  Optional[Array[Knot::Record::Caa]]          $caa          = undef,
  Optional[Array[Knot::Record::Tlsa]]         $tlsa         = undef,
  Optional[Array[Knot::Record::Service]]      $tlsa_service = undef,
) {
  $_target_zone = pick($target_zone, knot::zone($title))
  $_rname       = pick($rname, knot::hname($title))

  include knot::records::defaults::webserver

  $_ipv4 = pick($ipv4, $knot::records::defaults::webserver::ipv4, false)
  $_ipv6 = pick($ipv6, $knot::records::defaults::webserver::ipv6, false)
  $_alpn = pick($alpn, $knot::records::defaults::webserver::alpn)

  $_caa = pick($caa, $knot::records::defaults::webserver::caa)
  $_tlsa = pick($tlsa, $knot::records::defaults::webserver::tlsa)
  $_tlsa_service = pick($tlsa_service, $knot::records::defaults::webserver::tlsa_service)

  $_ttl = pick($ttl, $knot::records::defaults::webserver::ttl)

  if $_ipv4 {
    knot_record { "ipv4: ${title}":
      target_zone => $_target_zone,
      rname       => $_rname,
      rtype       => 'A',
      rttl        => $_ttl,
      rcontent    => $_ipv4,
    }
  }

  if $_ipv6 {
    knot_record { "ipv6: ${title}":
      target_zone => $_target_zone,
      rname       => $_rname,
      rtype       => 'AAAA',
      rttl        => $_ttl,
      rcontent    => $_ipv6,
    }
  }

  knot::records::caa { "webserver CAA ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    caa         => $_caa,
  }

  knot::records::tlsa { "webserver TLSA ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    tlsa        => $_tlsa,
    service     => $_tlsa_service,
  }

  # TODO:
  # $_alpn.each | Integer $i, String[1] $v | {
  #   knot_record { "alpn: ${title} (${i})":
  #     target_zone => $_target_zone,
  #     rname       => $_rname,
  #     rttl        => $_ttl,
  #     rtype       => 'HTTPS',
  #     rcontent    => "0 issue ${v}",
  #   }
  # }
}
