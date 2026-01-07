# @summary add caa records to the domain
# 
# default values can be configured in the class
# knot::records::defaults::caa which is included
# here (eg in hiera).
#
# @param rname
#  the hostname to add
# @param target_zone
#  the target zone to add the records
# @param caa
#  the CAA record(s)
#  default from knot::records::defaults::caa
# @param ttl
#  the time to live (used for all records)
#  default from knot::records::defaults::caa
#
define knot::records::caa (
  Optional[String[1]]                 $rname       = undef,
  Optional[String[1]]                 $target_zone = undef,
  Optional[Array[Knot::Record::Caa]]  $caa         = undef,
  Optional[Integer]                   $ttl         = undef,
) {
  $_target_zone = pick($target_zone, knot::zone($title))
  $_rname       = pick($rname, knot::hname($title))

  include knot::records::defaults::caa

  $_caa = pick($caa, $knot::records::defaults::caa::caa)
  $_ttl = pick($ttl, $knot::records::defaults::caa::ttl)

  $_caa.each | Integer $i, Knot::Record::Caa $v | {
    knot_record { "caa: ${title} (${i})":
      target_zone => $_target_zone,
      rname       => $_rname,
      rttl        => $_ttl,
      rtype       => 'CAA',
      rcontent    => "${v['flags']} ${v['tag']} \"${v['value']}\" ",
    }
  }
}
