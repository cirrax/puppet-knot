# @summary MX record type
# 
type Knot::Record::Mx = Struct[{
  'prio'   => Integer[0,255],
  'target' => String[1],
}]
