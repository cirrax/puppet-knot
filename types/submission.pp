# @summary submission configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#submission-section
type Knot::Submission = Struct[{
  'comment'        => Optional[String[1]],
  'id'             => String[1],
  'parent'         => Optional[Array[String[1]]],
  'check-interval' => Optional[Knot::Subtypes::Time],
  'timeout'        => Optional[Knot::Subtypes::Time],
  'parent-delay'   => Optional[Knot::Subtypes::Time],
}]
