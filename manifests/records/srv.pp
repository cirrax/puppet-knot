# @summary add srv records
# 
# default values can be configured in the class
# knot::records::defaults::srv which is included
# here (eg in hiera).
#
# @param rname
#  the hostname to add
# @param target_zone
#  the target zone to add the records
# @param srv
#  the SRV record(s)
#  default from knot::records::defaults::srv
# @param service
#  an array of services
# @param ttl
#  the time to live (used for all records)
#  default from knot::records::defaults::srv
#
define knot::records::srv (
  Optional[String[1]]                    $rname       = undef,
  Optional[String[1]]                    $target_zone = undef,
  Optional[Array[Knot::Record::Srv]]     $srv         = undef,
  Optional[Array[Knot::Record::Service]] $service     = undef,
  Optional[Integer]                      $ttl         = undef,
) {
  $_target_zone = pick($target_zone, knot::zone($title))
  $_rname       = pick($rname, knot::hname($title))

  include knot::records::defaults::srv

  $_srv = pick($srv, $knot::records::defaults::srv::srv)
  $_service = pick($service, $knot::records::defaults::srv::service)
  $_ttl = pick($ttl, $knot::records::defaults::srv::ttl)

  $_service.each | Knot::Record::Service $serv | {
    $_srv.each | Integer $i, Knot::Record::Srv $v | {
      if $_rname == '.' {
        $rname_final="_${serv['port']}._${serv['proto']}"
      } else {
        $rname_final="_${serv['port']}._${serv['proto']}.${_rname}"
      }

      knot_record { "srv (${serv['port']}, ${serv['proto']}): ${title} (${i})":
        target_zone => $_target_zone,
        rname       => $rname_final,
        rttl        => $_ttl,
        rtype       => 'SRV',
        rcontent    => "${v['priority']} ${v['weight']} ${v['target_port']} ${v['target']}",
      }
    }
  }
}
