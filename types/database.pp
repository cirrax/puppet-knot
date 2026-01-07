# @summary database configuration section
# @see https://www.knot-dns.cz/docs/latest/html/reference.html#database-section
type Knot::Database = Struct[{
  'comment'               => Optional[String[1]],
  'storage'               => Optional[String[1]],
  'journal-db'            => Optional[String[1]],
  'journal-db-mode'       => Optional[Enum['robust', 'asynchronous']],
  'journal-db-max-size'   => Optional[Knot::Subtypes::Size],
  'kasp-db'               => Optional[String[1]],
  'kasp-db-max-size'      => Optional[Knot::Subtypes::Size],
  'timer-db'              => Optional[String[1]],
  'timer-db-max-size'     => Optional[Knot::Subtypes::Size],
  'timer-db-sync'         => Optional[Variant[Enum['never', 'shutdown', 'immediate'], Knot::Subtypes::Time]],
  'catalog-db'            => Optional[String[1]],
  'catalog-db-max-size'   => Optional[Knot::Subtypes::Size],
  'zone-db-listen'        => Optional[Array[String[1]]],
  'zone-db-tls'           => Optional[Boolean],
  'zone-db-cert-key'      => Optional[Knot::Subtypes::Hexstr],
  'zone-db-cert-hostname' => Optional[String[1]],
}]
