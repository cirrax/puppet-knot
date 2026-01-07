# @summary a record in a domain
# used to create records using knot_record resource
type Knot::Record = Struct[{
  'rname'    => String[1],
  'rcontent' => String[1],
  'rclass'   => Optional[String[1]],
  'rtype'    => Optional[String[1]],
  'rttl'     => Optional[String[1]],
}]
