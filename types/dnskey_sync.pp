# @summary dnskey-sync configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#dnskey-sync-section
type Knot::Dnskey_sync = Struct[{
  'comment'        => Optional[String[1]],
  'id'             => String[1],
  'remote'         => Option[Array[String[1]]],
  'check-interval' => Optional[Knot::Subtypes::Time],
}]
