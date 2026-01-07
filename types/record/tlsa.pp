# @summary TLSA record type
# @see https://www.rfc-editor.org/rfc/rfc6698
# @see https://www.rfc-editor.org/rfc/rfc7218
# 
type Knot::Record::Tlsa = Struct[{
  'usage'    => Integer[0,255],
  'selector' => Integer[0,255],
  'matching' => Integer[0,255],
  'value'    => String[1],
}]
