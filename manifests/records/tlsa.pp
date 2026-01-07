# @summary add tlsa records
# 
# default values can be configured in the class
# knot::records::defaults::tlsa which is included
# here (eg in hiera).
#
# @param rname
#  the hostname to add
# @param target_zone
#  the target zone to add the records
# @param tlsa
#  the TLSA record(s)
#  default from knot::records::defaults::tlsa
# @param service
#  an array of services
# @param ttl
#  the time to live (used for all records)
#  default from knot::records::defaults::tlsa
#
define knot::records::tlsa (
  Optional[String[1]]                    $rname       = undef,
  Optional[String[1]]                    $target_zone = undef,
  Optional[Array[Knot::Record::Tlsa]]    $tlsa        = undef,
  Optional[Array[Knot::Record::Service]] $service     = undef,
  Optional[Integer]                      $ttl         = undef,
) {
  $_target_zone = pick($target_zone, knot::zone($title))
  $_rname       = pick($rname, knot::hname($title))

  include knot::records::defaults::tlsa

  $_tlsa = pick($tlsa, $knot::records::defaults::tlsa::tlsa)
  $_service = pick($service, $knot::records::defaults::tlsa::service)
  $_ttl = pick($ttl, $knot::records::defaults::tlsa::ttl)

  $_service.each | Knot::Record::Service $serv | {
    $_tlsa.each | Integer $i, Knot::Record::Tlsa $v | {
      if $_rname == '.' {
        $rname_final="_${serv['port']}._${serv['proto']}"
      } else {
        $rname_final="_${serv['port']}._${serv['proto']}.${_rname}"
      }
      $tlsa_val = upcase($v['value'])

      knot_record { "tlsa (${serv['port']}, ${serv['proto']}): ${title} (${i})":
        target_zone => $_target_zone,
        rname       => $rname_final,
        rttl        => $_ttl,
        rtype       => 'TLSA',
        rcontent    => "${v['usage']} ${v['selector']} ${v['matching']} ${tlsa_val}",
      }
    }
  }
}
