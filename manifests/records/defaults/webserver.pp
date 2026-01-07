# @summary default values for knot::records::webserver 
# 
# this class add the defaults used in knot::records::webserver
# for adding the records.
#
# @param ipv4
#  the ipv4 address (A record)
# @param ipv6
#  the ipv4 address (AAAA record)
# @param alpn
#  the ALPN record
# @param ttl
#  the time to live
# @param caa
#  caa records to create (using define knot::records::caa)
# @param tlsa 
#  tlsa records to create (using define knot::records::tlsa)
# @param tlsa_service 
#  tlsa service records to create (using define knot::records::tlsa)
#
class knot::records::defaults::webserver (
  Optional[Stdlib::IP::Address::V4::Nosubnet] $ipv4         = undef,
  Optional[Stdlib::IP::Address::V6::Nosubnet] $ipv6         = undef,
  Array[String[1]]                            $alpn         = [],
  Integer                                     $ttl          = 3600,
  Array[Knot::Record::Caa]                    $caa          = [],
  Array[Knot::Record::Tlsa]                   $tlsa         = [],
  Array[Knot::Record::Service]                $tlsa_service = [],
) {
}
