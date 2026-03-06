# @summary CSYNC record type
# @see https://www.rfc-editor.org/rfc/rfc7477
# 
type Knot::Record::Csync = Struct[{
  'flags'  => Integer[0,255],
  'serial' => Integer,
  'value'  => String[1],
}]
