# @summary a subzone definition
# 
type Knot::Subzone = Struct[{
  'nameservers' => Optional[Array[String[1]]],
  'trust_ds'    => Optional[Array[String[1]]],
  'ttl'         => Optional[Integer],
}]
