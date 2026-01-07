# @summary defaults for tlsa records
# 
# @param tlsa
#  the TLSA record(s)
# @param service
#  an array of services
# @param ttl
#  the time to live (used for all records)
#
class knot::records::defaults::tlsa (
  Array[Knot::Record::Tlsa]    $tlsa    = [],
  Array[Knot::Record::Service] $service = [],
  Integer                      $ttl     = 3600,
) {
}
