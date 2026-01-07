# @summary default values for knot::records::caa
# 
# this class add the defaults used in knot::records::caa
# for adding the records.
#
# @param caa
#  the CAA record(s)
#  default from knot::records::defaults::caa
# @param ttl
#  the time to live (used for all records)
#
class knot::records::defaults::caa (
  Array[Knot::Record::Caa] $caa = [],
  Integer                  $ttl = 3600,
) {
}
