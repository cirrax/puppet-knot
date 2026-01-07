# @summary acl configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#acl-section
type Knot::Acl = Struct[{
  'comment'            => Optional[String[1]],
  'id'                 => String[1],
  'address'            => Optional[Array[String[1]]],
  'key'                => Optional[Array[String[1]]],
  'cert-key'           => Optional[Array[Knot::Subtypes::Base64]],
  'cert-hostname'      => Optional[Array[String[1]]],
  'remote'             => Optional[Array[String[1]]],
  'action'             => Optional[Variant[
    Array[Enum['query', 'notify', 'transfer', 'update']],
  Enum['query', 'notify', 'transfer', 'update']]],
  'protocol'           => Optional[Array[Enum['udp', 'tcp', 'tls', 'quic']]],
  'deny'               => Optional[Boolean],
  'update-type'        => Optional[Array[String[1]]],
  'update-owner'       => Optional[Enum['key', 'zone', 'name']],
  'update-owner-match' => Optional[Enum['sub-or-equal', 'equal', 'sub', 'pattern']],
  'update-owner-name'  => Optional[Array[String[1]]],
}]
