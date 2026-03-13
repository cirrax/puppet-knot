# @summary add svcb records
# 
# default values can be configured in the class
# knot::records::defaults::tlsa which is included
# here (eg in hiera).
#
# @param rname
#  the hostname to add
# @param target_zone
#  the target zone to add the records
# @param type
#  one of SCVB or HTTPS
# @param svcb
#  the SVCB record
# @param ttl
#  the time to live
#
define knot::records::svcb (
  Optional[String[1]]       $rname       = undef,
  Optional[String[1]]       $target_zone = undef,
  Enum['SVCB','HTTPS']      $type        = 'SVCB',
  Array[Knot::Record::Svcb] $svcb        = [],
  Integer                   $ttl         = 3600,
) {
  $_target_zone = pick($target_zone, knot::zone($title))
  $_rname       = pick($rname, knot::hname($title))

  $svcb.each | Integer $i, Knot::Record::Svcb $v | {
    knot_record { "svcb for ${title} (${i})":
      target_zone => $_target_zone,
      rname       => $_rname,
      rttl        => $ttl,
      rtype       => $type,
      rcontent    => epp('knot/svcb.epp', { 'priority' => 1, 'target' => '.' } + $v ),
    }
  }
}
