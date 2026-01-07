# @summary remote configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#remote-section
type Knot::Remote = Struct[{
  'comment'                     => Optional[String[1]],
  'id'                          => String[1],
  'address'                     => Optional[Variant[String[1],Array[String[1]]]],
  'via'                         => Optional[Array[String[1]]],
  'quic'                        => Optional[Boolean],
  'tls'                         => Optional[Boolean],
  'key'                         => Optional[Knot::Subtypes::Dname],
  'cert-key'                    => Optional[Knot::Subtypes::Base64],
  'cert-hostname'               => Optional[Array[String[1]]],
  'block-notify-after-transfer' => Optional[Boolean],
  'no-edns'                     => Optional[Boolean],
  'automatic-acl'               => Optional[Boolean],
}]
