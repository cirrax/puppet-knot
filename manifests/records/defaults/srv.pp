# @summary defaults for srv records
# 
# @param srv
#  the SRV record(s)
# @param service
#  an array of services
# @param ttl
#  the time to live (used for all records)
#
class knot::records::defaults::srv (
  Array[Knot::Record::Srv]     $srv         = [],
  Array[Knot::Record::Service] $service     = [],
  Integer                      $ttl         = 3600,
) {
}
