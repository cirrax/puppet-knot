# @summary service RR  such as used for TLSA or SRV
# @see https://www.rfc-editor.org/rfc/rfc2782 (for SRV)
# 
type Knot::Record::Service = Struct[{
  'port'  => Variant[Integer[0], String[1]],
  'proto' => Enum['udp', 'tcp'],
}]
