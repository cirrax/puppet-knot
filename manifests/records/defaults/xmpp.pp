# @summary default settings for knot::records::xmpp
# 
# @param xmpp_client
#  srv setting for SRV record of xmpp_client
#  if not explicitly set { target => $dest_server } will be added.
# @param xmpp_client_service
#  Array of services for xmpp_client.
# @param xmpps_client
#  srv setting for SRV record of xmpps_client
#  if not explicitly set { target => $dest_server } will be added.
# @param xmpps_client_service
#  Array of services for xmpps_client.
# @param xmpp_server
#  srv setting for SRV record of xmpp_server
#  if not explicitly set { target => $dest_server } will be added.
# @param xmpp_server_service
#  Array of services for xmpp_server.
# @param xmpps_server
#  srv setting for SRV record of xmpps_server
#  if not explicitly set { target => $dest_server } will be added.
# @param xmpps_server_service
#  Array of services for xmpps_server.
# @param txt_records
#  add _xmppconnect txt records.
# @param tlsa
#  tlsa records to create (using define knot::records::tlsa)
# @param ttl
#  the time to live (used for all records)
#
class knot::records::defaults::xmpp (
  Array                         $xmpp_client          = [{ 'priority' => 0, 'weight' => 5, 'target_port' => 5222 }],
  Array[Knot::Record::Service]  $xmpp_client_service  = [{ 'port' => 'xmpp-client', 'proto' => 'tcp' }],
  Array                         $xmpps_client         = [{ 'priority' => 0, 'weight' => 5, 'target_port' => 5223 }],
  Array[Knot::Record::Service]  $xmpps_client_service = [{ 'port' => 'xmpps-client', 'proto' => 'tcp' }],
  Array                         $xmpp_server          = [{ 'priority' => 0, 'weight' => 5, 'target_port' => 5269 }],
  Array[Knot::Record::Service]  $xmpp_server_service  = [{ 'port' => 'xmpp-server', 'proto' => 'tcp' }],
  Array                         $xmpps_server         = [{ 'priority' => 0, 'weight' => 5, 'target_port' => 5270 }],
  Array[Knot::Record::Service]  $xmpps_server_service = [{ 'port' => 'xmpps-server', 'proto' => 'tcp' }],
  Array[Knot::Record::Tlsa]     $tlsa                 = [],
  Array[String[1]]              $txt_records          = [],
  Integer                       $ttl                  = 3600,
) {
}
