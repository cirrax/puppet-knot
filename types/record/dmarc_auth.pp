# @summary Dmarc report authorization
# @see https://dmarc.org/2015/08/receiving-dmarc-reports-outside-your-domain/
# @see https://datatracker.ietf.org/doc/html/rfc7489 (section 7.1)
# 
type Knot::Record::Dmarc_auth = Struct[{
  'target_zone' => String[1],
  'record'      => String[1],
}]
