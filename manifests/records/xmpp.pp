# @summary add srv records
# 
# default values can be configured in the class
# knot::records::defaults::srv which is included
# here (eg in hiera).
#
# @param dest_server
#  the destination xmpp server
# @param rname
#  the hostname to add
# @param target_zone
#  the target zone to add the records
# @param xmpp_client
#  srv setting for SRV record of xmpp_client
#  if not explicitly set { target => $dest_server } will be added.
#  default from knot::records::defaults::xmpp
# @param xmpp_client_service
#  Array of services for xmpp_client.
#  default from knot::records::defaults::xmpp
# @param xmpps_client
#  srv setting for SRV record of xmpps_client
#  if not explicitly set { target => $dest_server } will be added.
#  default from knot::records::defaults::xmpp
# @param xmpps_client_service
#  Array of services for xmpps_client.
#  default from knot::records::defaults::xmpp
# @param xmpp_server
#  srv setting for SRV record of xmpp_server
#  if not explicitly set { target => $dest_server } will be added.
#  default from knot::records::defaults::xmpp
# @param xmpp_server_service
#  Array of services for xmpp_server.
#  default from knot::records::defaults::xmpp
# @param xmpps_server
#  srv setting for SRV record of xmpps_server
#  if not explicitly set { target => $dest_server } will be added.
#  default from knot::records::defaults::xmpp
# @param xmpps_server_service
#  Array of services for xmpps_server.
#  default from knot::records::defaults::xmpp
# @param ttl
#  the time to live (used for all records)
#  default from knot::records::defaults::xmpp
# @param txt_records
#  add _xmppconnect txt records.
#  remark: deprecated but ...
# @param tlsa
#  tlsa records to create (using define knot::records::tlsa)
#  default from knot::records::defaults::xmpp
# @param tlsa_service
#  tlsa services to create tlsa records for (using define knot::records::tlsa)
#  defaults to the target ports of $xmpps_server + $xmpps_client
#
define knot::records::xmpp (
  String[1]                               $dest_server,
  Optional[String[1]]                     $rname                = undef,
  Optional[String[1]]                     $target_zone          = undef,
  Optional[Array]                         $xmpp_client          = undef,
  Optional[Array[Knot::Record::Service]]  $xmpp_client_service  = undef,
  Optional[Array]                         $xmpps_client         = undef,
  Optional[Array[Knot::Record::Service]]  $xmpps_client_service = undef,
  Optional[Array]                         $xmpp_server          = undef,
  Optional[Array[Knot::Record::Service]]  $xmpp_server_service  = undef,
  Optional[Array]                         $xmpps_server         = undef,
  Optional[Array[Knot::Record::Service]]  $xmpps_server_service = undef,
  Optional[Integer]                       $ttl                  = undef,
  Optional[Array[String[1]]]              $txt_records          = undef,
  Optional[Array[Knot::Record::Tlsa]]     $tlsa                 = undef,
  Optional[Array[Knot::Record::Service]]  $tlsa_service         = undef,
) {
  $_target_zone = pick($target_zone, knot::zone($title))
  $_rname       = pick($rname, knot::hname($title))

  include knot::records::defaults::xmpp

  $_xmpp_client = pick($xmpp_client, $knot::records::defaults::xmpp::xmpp_client)
  $_xmpp_client_service = pick($xmpp_client_service, $knot::records::defaults::xmpp::xmpp_client_service)
  $_xmpps_client = pick($xmpps_client, $knot::records::defaults::xmpp::xmpps_client)
  $_xmpps_client_service = pick($xmpps_client_service, $knot::records::defaults::xmpp::xmpps_client_service)
  $_xmpp_server = pick($xmpp_server, $knot::records::defaults::xmpp::xmpp_server)
  $_xmpp_server_service = pick($xmpp_server_service, $knot::records::defaults::xmpp::xmpp_server_service)
  $_xmpps_server = pick($xmpps_server, $knot::records::defaults::xmpp::xmpps_server)
  $_xmpps_server_service = pick($xmpps_server_service, $knot::records::defaults::xmpp::xmpps_server_service)
  $_ttl = pick($ttl, $knot::records::defaults::xmpp::ttl)
  $_txt_records = pick($txt_records, $knot::records::defaults::xmpp::txt_records)

  $_tlsa = pick($tlsa, $knot::records::defaults::xmpp::tlsa)

  if $tlsa_service {
    $_tlsa_service = $tlsa_service
  } else {
    $_tlsa_service = ($_xmpps_client + $_xmpps_server).map | $t | {
      { 'port' => $t['target_port'], 'proto' => 'tcp' }
    }
  }

  knot::records::srv { "SRV xmpp-client ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    srv         => $_xmpp_client.map | $t | { { 'target' => $dest_server } + $t },
    service     => $_xmpp_client_service,
    ttl         => $_ttl,
  }
  knot::records::srv { "SRV xmpps-client ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    srv         => $_xmpps_client.map | $t | { { 'target' => $dest_server } + $t },
    service     => $_xmpps_client_service,
    ttl         => $_ttl,
  }

  knot::records::srv { "SRV xmpp-server ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    srv         => $_xmpp_server.map | $t | { { 'target' => $dest_server } + $t },
    service     => $_xmpp_server_service,
    ttl         => $_ttl,
  }
  knot::records::srv { "SRV xmpps-server ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    srv         => $_xmpps_server.map | $t | { { 'target' => $dest_server } + $t },
    service     => $_xmpps_server_service,
    ttl         => $_ttl,
  }

  knot::records::tlsa { "XMPPS TLSA ${title}":
    target_zone => $_target_zone,
    rname       => $_rname,
    tlsa        => $_tlsa,
    ttl         => $_ttl,
    service     => $_tlsa_service,
  }

  $_txt_records.each | String[1] $r | {
    if $_rname == '.' {
      $_txt_rname = '_xmppconnect'
    } else {
      $_txt_rname = "_xmppconnect.${_rname}"
    }
    knot_record { "TXT xmpp for ${title} (${r})":
      target_zone => $_target_zone,
      rname       => $_txt_rname,
      rtype       => 'TXT',
      rttl        => $_ttl,
      rcontent    => "\"${r}\"",
    }
  }
}
