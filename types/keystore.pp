# @summary keystore configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#keystore-section
type Knot::Keystore = Struct[{
  'comment'   => Optional[String[1]],
  'id'        => String[1],
  'backend'   => Optional[Enum['pem','pkcs11']],
  'config'    => Optional[String[1]],
  'ksk-only'  => Optional[Boolean],
  'key-label' => Optional[Boolean],
}]
