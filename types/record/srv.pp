# @summary SRV record type
# @see https://www.rfc-editor.org/rfc/rfc2782
# 
type Knot::Record::Srv = Struct[{
  'priority'    => Integer[0,65535],
  'weight'      => Integer[0,65535],
  'target_port' => Integer[0],
  'target'      => String[1],
}]
