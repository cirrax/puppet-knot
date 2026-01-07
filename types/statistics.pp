# @summary statistics configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#statistics-section
type Knot::Statistics = Struct[{
  'comment' => Optional[String[1]],
  'timer'   => Optional[Knot::Subtypes::Time],
  'file'    => Optional[String[1]],
  'append'  => Optional[Boolean],
}]
