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
# @param rev4_target_split
#  if this is set a reverse ipv4 PTR record is generated and added to
#  the respective reverse zone (asuming that puppet can manage records
#  in the domain (zone_manage_records == true).
#  The integer you set gives the parts taken for the hostname.
#  eg. setting rev4_target_split = 1 for ip 1.2.3.4 results in
#  a PTR record for 1 on target zone 3.2.1.in-addr.arpa
# @param rev6_target_split
#  if this is set a reverse ipv6 PTR record is generated and added to
#  the respective reverse zone (asuming that puppet can manage records
#  in the domain (zone_manage_records == true).
#  The integer you set gives the parts taken for the hostname.
#  eg. setting rev6_target_split = 21 for ip ::1 results in
#  a PTR record for 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0
#  on target zone 0.0.0.0.0.0.0.0.0.0.0.ip6.arpa
#
define knot::records::network (
  String[1]                           $target_zone,
  Hash[String[1],Hash[String[1],Any]] $hostlist          = {},
  Integer                             $ttl               = 3600,
  String[1]                           $ipv4_key          = 'ipv4',
  String[1]                           $ipv6_key          = 'ipv6',
  Optional[Integer[1,4]]              $rev4_target_split = undef,
  Optional[Integer[1,32]]             $rev6_target_split = undef,
) {
  $hostlist.each | String[1] $rname, Hash[String[1],Any] $vals | {
    if $ipv4_key in $vals.keys() {
      knot_record { "ipv4: ${title} ${rname}.${target_zone}":
        target_zone => $target_zone,
        rname       => $rname.downcase(),
        rtype       => 'A',
        rttl        => $ttl,
        rcontent    => $vals.get($ipv4_key),
      }
      if $rev4_target_split {
        knot_record { "ipv4 reverse: ${title} for ${rname}.${target_zone}":
          target_zone => knot::reverse4_target($vals.get($ipv4_key),$rev4_target_split),
          rname       => knot::reverse4_host($vals.get($ipv4_key),$rev4_target_split),
          rtype       => 'PTR',
          rttl        => $ttl,
          rcontent    => "${rname}.${target_zone}.".downcase(),
        }
      }
    }

    if $ipv6_key in $vals.keys() {
      knot_record { "ipv6: ${title} ${rname}.${target_zone}":
        target_zone => $target_zone,
        rname       => $rname.downcase(),
        rtype       => 'AAAA',
        rttl        => $ttl,
        rcontent    => $vals.get($ipv6_key),
      }
      if $rev6_target_split {
        knot_record { "ipv6 reverse: ${title} for ${rname}.${target_zone}":
          target_zone => knot::reverse6_target($vals.get($ipv6_key),$rev6_target_split),
          rname       => knot::reverse6_host($vals.get($ipv6_key),$rev6_target_split),
          rtype       => 'PTR',
          rttl        => $ttl,
          rcontent    => "${rname}.${target_zone}.".downcase(),
        }
      }
    }
  }
}
