# @summary key configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#key-section
type Knot::Key = Struct[{
  'comment'   => Optional[String[1]],
  'id'        => Knot::Subtypes::Dname,
  'algorithm' => Optional[Enum['hmac-md5', 'hmac-sha1', 'hmac-sha224', 'hmac-sha256', 'hmac-sha384', 'hmac-sha512']],
  'secret'    => Knot::Subtypes::Base64,
}]
