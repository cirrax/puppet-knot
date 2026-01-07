# @summary convert a hash into dns records
# 
# this converts a hash of hosts
# IN A and IN AAAA records
#
# @param target_zone
#  the target zone to add the records
# @param hostlist
#  a list of hosts of the form
#  { hostname => {ipv4 => 1.1.1.1, ipv6 => ::1}, hostname2 => ... 
#  keys used are ipv4 and ipv6 (or whatever is specified in 
#  $ipv4_key resp. $ipv6_key. Additional keys are explicitly allowed,
#  but not used.
# @param ttl
#  the ttl to use
# @param ipv4_key 
#  the key for ipv4 records
# @param ipv6_key 
#  the key for ipv6 records
#
define knot::records::network (
  String[1]                           $target_zone,
  Hash[String[1],Hash[String[1],Any]] $hostlist     = {},
  Integer                             $ttl          = 3600,
  String[1]                           $ipv4_key     = 'ipv4',
  String[1]                           $ipv6_key     = 'ipv4',
) {
  $hostlist.each | String[1] $rname, Hash[String[1],Any] $vals | {
    if $ipv4_key in $vals.keys() {
      knot_record { "ipv4: ${title} ${rname}.${target_zone}":
        target_zone => $target_zone,
        rname       => $rname,
        rtype       => 'A',
        rttl        => $ttl,
        rcontent    => $vals.getvar($ipv4_key),
      }
    }

    if $ipv6_key in $vals.keys() {
      knot_record { "ipv6: ${title} ${rname}.${target_zone}":
        target_zone => $target_zone,
        rname       => $rname,
        rtype       => 'AAAA',
        rttl        => $ttl,
        rcontent    => $vals.getvar($ipv6_key),
      }
    }
  }
}
