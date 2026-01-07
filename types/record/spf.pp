# @summary SPF record type
# @see https://www.rfc-editor.org/rfc/rfc7208
# 
type Knot::Record::Spf = Struct[{
  'version'   => String[1],
  'mechanism' => Array[String[1]],
  'modifier'  => Array[String[1]],
}]
