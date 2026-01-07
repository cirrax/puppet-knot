# @summary xdp configuration section
# @see https://www.knot-dns.cz/docs/latest/html/reference.html#xdp-section
type Knot::Xdp = Struct[{
  'comment'                => Optional[String[1]],
  'listen'                 => Optional[Array[String[1]]],
  'udp'                    => Optional[Boolean],
  'tcp'                    => Optional[Boolean],
  'quick'                  => Optional[Boolean],
  'quic-port'              => Optional[Integer],
  'tcp-max-clients'        => Optional[Integer],
  'tcp-inbuf-max-size'     => Optional[Knot::Subtypes::Size],
  'tcp-outbuf-max-size'    => Optional[Knot::Subtypes::Size],
  'tcp-idle-close-timeout' => Optional[Knot::Subtypes::Time],
  'tcp-idle-reset-timeout' => Optional[Knot::Subtypes::Size],
  'tcp-resend-timeout'     => Optional[Knot::Subtypes::Size],
  'route-check'            => Optional[Boolean],
  'ring-size'              => Optional[Integer],
  'busypoll-budget'        => Optional[Integer],
  'busypoll-timeout'       => Optional[Integer],
}]
