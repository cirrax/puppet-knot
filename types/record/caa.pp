# @summary CAA record type
# @see https://datatracker.ietf.org/doc/html/rfc8659
# @see https://datatracker.ietf.org/doc/html/rfc8657
# 
# parameters mentioned in rfc8657 must currently
# be mentioned in value
type Knot::Record::Caa = Struct[{
  'flags'  => Integer[0,255],
  'tag'    => Enum['issue','issuewild','iodef'],
  'value'  => String[1],
}]
