# @summary control configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#control-section
type Knot::Control = Struct[{
  'comment' => Optional[String[1]],
  'listen'  => Optional[Array[String[1]]],
  'backlog' => Optional[Integer],
  'timeout' => Optional[Knot::Subtypes::Time],
}]
