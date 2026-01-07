# @summary control configuration section
# @see https://www.knot_dns.cz/docs/latest/html/reference.html#control-section
type Knot::Log = Struct[{
  'comment' => Optional[String[1]],
  'target'  => Variant[Enum['stdout', 'stderr', 'syslog'], String[1]],
  'server'  => Optional[Enum['critical', 'error', 'warning', 'notice', 'info', 'debug']],
  'control' => Optional[Enum['critical', 'error', 'warning', 'notice', 'info', 'debug']],
  'zone'    => Optional[Enum['critical', 'error', 'warning', 'notice', 'info', 'debug']],
  'quic'    => Optional[Enum['critical', 'error', 'warning', 'notice', 'info', 'debug']],
  'any'     => Optional[Enum['critical', 'error', 'warning', 'notice', 'info', 'debug']],
}]
