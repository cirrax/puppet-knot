# @summary a range of records in a domain 
# used to create records using knot_record resource
# it's Knot::Record with the addition of a range
type Knot::Record_generate = Struct[{
  'rname'    => String[1],
  'rcontent' => String[1],
  'rclass'   => Optional[String[1]],
  'rtype'    => Optional[String[1]],
  'rttl'     => Optional[String[1]],
  'range'    => Tuple[Integer,Integer],
}]
