# @summary external configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#external-section
type Knot::External = Struct[{
  'comment'        => Optional[String[1]],
  'id'             => String[1],
  'timeout'        => Optional[Knot::Subtypes::Time],
  'dump-new-zone'  => Optional[String[1]],
  'dump-removals'  => Optional[String[1]],
  'dump-additions' => Optional[String[1]],
}]
