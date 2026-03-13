# @summary SVCB/HTTPS record type
# @see https://www.rfc-editor.org/rfc/rfc9460
# 
type Knot::Record::SVCB = Struct[{
  'priority' => Optional[Integer],
  'target'   => Optional[String[1]],
  'port'     => Optional[Integer],
  'alpn'     => Optional[Array[String[1]]],
  'ipv4hint' => Optional[Array[Stdlib::IP::Address::V4::Nosubnet]],
  'ipv6hint' => Optional[Array[Stdlib::IP::Address::V6::Nosubnet]],
}]
