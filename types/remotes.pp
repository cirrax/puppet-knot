# @summary remotes configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#remotes-section
type Knot::Remotes = Struct[{
  'comment' => Optional[String[1]],
  'id'      => String[1],
  'remote'  => Optional[Array[String[1]]],
}]
