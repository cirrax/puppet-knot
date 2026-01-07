# shortcut to add a domain configuration to the config:
# - adds a zone to the config file (uses knot::add_conf)
#
# for the config file parameters see:
# https://www.knot-dns.cz/docs/latest/html/reference.html#zone-section
#
# @param ensure
# @param domain
#   the domain to manage
# @param comment
#   a comment
# @param template
#   A reference to a configuration template.
# @param storage
#   A data directory for storing zone files.
# @param file
#   A path to the zone file.
# @param zone_db_input
#   If set, the zone is loaded from the zone database configured at zone-db-listen.
# @param zone_db_output
#   If set, the zone is stored to the zone database configured at zone-db-listen
#   and updated there with every change to the zone contents.
# @param master
#   An ordered list of references remote and remotes to zone primary servers
#   (formerly known as master servers)
# @param ddns_master
#   A reference to a zone primary master where DDNS messages should be forwarded to.
# @param send_notify
#   An ordered list of references remote and remotes to secondary servers to
#   which NOTIFY message is sent if the zone changes
# @param notify_delay
#   A time delay in seconds before an outgoing NOTIFY message is sent.
# @param update_delay
#   A time delay in seconds before a change to zone contents is made after an external trigger.
# @param acl
#   An ordered list of references to ACL rules which can allow or 
#   disallow zone transfers, updates or incoming notifies.
# @param master_pin_tolerance
#   If set to a nonzero value on a secondary, always request AXFR/IXFR from the
#   same primary as the last time, effectively pinning one primary. 
# @param provide_ixfr
#   If disabled, the server is forced to respond with AXFR to IXFR queries.
# @param semantic_checks
#   Selects if extra zone semantic checks are used or impacts of the mandatory checks.
# @param default_ttl
#   The default TTL value if none is specified in a zone file or zone insertion
#   using the dynamic configuration.
# @param zonefile_sync
#   The time in seconds after which the current zone in memory will be synced with a zone file on the disk.
# @param zonefile_load
#   Selects how the zone file contents are applied during zone load.
# @param zonefile_skip
#   Specifies resource record types to be omitted when loading and syncing zone files.
# @param journal_content
#   Selects how the journal shall be used to store zone and its changes.
# @param journal_max_usage
#   Policy how much space in journal DB will the zone's journal occupy.
# @param journal_max_depth
#   Maximum history length of the journal.
# @param ixfr_benevolent
#   If enabled, incoming IXFR is applied even when it contains removals of
#   non-existing or additions of existing records.
# @param ixfr_by_one
#   Within incoming IXFR, process only one changeset at a time, not multiple together.
# @param ixfr_from_axfr
#   If a primary sends AXFR-style-IXFR upon an IXFR request, compute the difference and
#   process it as an incremental zone update.
# @param zone_max_size
#   Maximum size of the zone.
# @param adjust_threads
#   Parallelize internal zone adjusting procedures by using specified number of threads.
# @param external_validation
#   If configured, every change to the zone is paused just before applying the new zone.
# @param dnssec_signing
#   If enabled, automatic DNSSEC signing for the zone is turned on.
# @param dnssec_validation
#   If enabled, the zone contents are validated for being correctly signed (including NSEC/NSEC3 chain)
#   with DNSSEC signatures every time the zone is loaded or changed (including AXFR/IXFR).
# @param dnssec_policy
#   A reference to DNSSEC signing policy.
# @param ds_push
#   Per zone configuration of ds-push.
# @param zonemd_verify
#   On each zone load/update, verify that ZONEMD is present in the zone and valid.
# @param zonemd_generate
#   On each zone update, calculate ZONEMD and put it into the zone.
# @param serial_policy
#   Specifies how the zone serial is updated after a dynamic update or automatic DNSSEC signing.
# @param serial_modulo
#   see knot parameter description about how this works !
# @param reverse_generate
#   A list of zone names for which automatic generation of reverse PTR records based on A/AAAA records is enabled.
# @param include_from
#   A list of subzones that should be flattened into this zone.
# @param refresh_min_interval
#   Forced minimum zone refresh interval (in seconds).
# @param refresh_max_interval
#   Forced maximum zone refresh interval (in seconds).
# @param retry_min_interval
#   Forced minimum zone retry interval (in seconds) to avoid flooding primary server.
# @param retry_max_interval
#   Forced maximum zone retry interval (in seconds).
# @param expire_min_interval
#   Forced minimum zone expire interval (in seconds) to avoid flooding primary server.
# @param expire_max_interval
#   Forced maximum zone expire interval (in seconds).
# @param catalog_role
#   Trigger zone catalog feature.
# @param catalog_template
#   For the catalog member zones, the specified configuration template will be applied.
# @param catalog_zone
#   Assign this member zone to specified generated catalog zone.
# @param catalog_group
#   Assign this member zone to specified catalog group (configuration template).
# @param module
#   An ordered list of references to query modules in the form of module_name or module_name/module_id.
# @param manage_zone
#   set this to true, if you want to apply the domain records with the knot_zone resource.
#   this allows you to manage dns records with puppet using knot_record resource.
#   leave this to false for secondary domains.
# @param zone_content_filter
#   regex for filtering out unwanted records by default filters dnssec records assuming you use autosigning.
#   remark: only relevant if $manage_zone set to true
# @param zone_show_diff
#   Whether to display differences when the zone changes, defaulting to
#   false. Since zones can be huge, use this only for debugging
#   remark: only relevant if $manage_zone set to true
# @param zone_manage_records
#   If puppet shall manage all zone records for the domain (any records not managed with puppet will be purged).
#   The default is true, to manage the SOA record and all zone records through puppet for the zone.
#   If set to false, ensurance of zone creation is done only and the administration of zone records needs to be done through
#   web Interface or any other preferred method.
#   remark: only relevant if $manage_zone set to true
# @param zone_soa_ttl
#   ttl for SOA record
#   remark: only relevant if $manage_zone set to true
# @param zone_soa_class
#   zone class for SOA record
#   remark: only relevant if $manage_zone set to true
# @param zone_soa_mname
#   primary master name server for the zone for SOA record
#   remark: only relevant if $manage_zone set to true
# @param zone_soa_rname
#   Email address of the administrator responsible for this zone for SOA record
#   remark: only relevant if $manage_zone set to true
# @param zone_soa_refresh
#   Number of seconds after which secondary name servers should query the master for the SOA record, to detect zone changes
#   remark: only relevant if $manage_zone set to true
# @param zone_soa_retry
#   Number of seconds after which secondary name servers should retry to request the serial number from the master if the master does not respond
#   remark: only relevant if $manage_zone set to true
# @param zone_soa_expire
#   Number of seconds after which secondary name servers should stop answering request for this zone if the master does not respond.
#   remark: only relevant if $manage_zone set to true
# @param zone_soa_minttl
#   Minimum ttl in seconds, negativ response caching ttl
#   remark: only relevant if $manage_zone set to true
# @param zone_records
#   array of records to add to the domain
#   remark: only relevant if $manage_zone set to true
# @param zone_nameservers
#   list of nameservers to add
#   remark: only relevant if $manage_zone set to true
# @param zone_nameservers_ttl
#   ttl to use for $zone_nameservers entries   
#   remark: only relevant if $manage_zone set to true
# @param zone_subzones
#   Hash of subzones to establish
#   remark: only relevant if $manage_zone set to true
#
define knot::domain (
  Enum['absent', 'present']                                             $ensure               = 'present',
  String[1]                                                             $domain               = $title,
  Optional[String[1]]                                                   $comment              = undef,
  Optional[String[1]]                                                   $template             = undef,
  Optional[String[1]]                                                   $storage              = undef,
  Optional[String[1]]                                                   $file                 = undef,
  Optional[Integer]                                                     $zone_db_input        = undef,
  Optional[String[1]]                                                   $zone_db_output       = undef,
  Optional[Array[String[1]]]                                            $master               = undef,
  Optional[String[1]]                                                   $ddns_master          = undef,
  Optional[Array[String[1]]]                                            $send_notify          = undef,
  Optional[Knot::Subtypes::Time]                                        $notify_delay         = undef,
  Optional[Knot::Subtypes::Time]                                        $update_delay         = undef,
  Optional[Array[String[1]]]                                            $acl                  = undef,
  Optional[Knot::Subtypes::Time]                                        $master_pin_tolerance = undef,
  Optional[Boolean]                                                     $provide_ixfr         = undef,
  Optional[Variant[Enum['soft'], Boolean]]                              $semantic_checks      = undef,
  Optional[Knot::Subtypes::Time]                                        $default_ttl          = undef,
  Optional[Knot::Subtypes::Time]                                        $zonefile_sync        = undef,
  Optional[Enum['none', 'difference', 'difference-no-serial', 'whole']] $zonefile_load        = undef,
  Optional[Array[String[1]]]                                            $zonefile_skip        = undef,
  Optional[Enum['none', 'changes', 'all']]                              $journal_content      = undef,
  Optional[Knot::Subtypes::Size]                                        $journal_max_usage    = undef,
  Optional[Integer]                                                     $journal_max_depth    = undef,
  Optional[Boolean]                                                     $ixfr_benevolent      = undef,
  Optional[Boolean]                                                     $ixfr_by_one          = undef,
  Optional[Boolean]                                                     $ixfr_from_axfr       = undef,
  Optional[Knot::Subtypes::Size]                                        $zone_max_size        = undef,
  Optional[String[1]]                                                   $adjust_threads       = undef,
  Optional[String[1]]                                                   $external_validation  = undef,
  Optional[Boolean]                                                     $dnssec_signing       = undef,
  Optional[Boolean]                                                     $dnssec_validation    = undef,
  Optional[String[1]]                                                   $dnssec_policy        = undef,
  Optional[Variant[String[1],Array[String[1]]]]                         $ds_push              = undef,
  Optional[Boolean]                                                     $zonemd_verify        = undef,
  Optional[Enum['none', 'zonemd-sha384', 'zonemd-sha512', 'remove']]    $zonemd_generate      = undef,
  Optional[Enum['increment', 'unixtime', 'dateserial']]                 $serial_policy        = undef,
  Optional[String[1]]                                                   $serial_modulo        = undef,
  Optional[Array[Knot::Subtypes::Dname]]                                $reverse_generate     = undef,
  Optional[Array[Knot::Subtypes::Dname]]                                $include_from         = undef,
  Optional[Knot::Subtypes::Time]                                        $refresh_min_interval = undef,
  Optional[Knot::Subtypes::Time]                                        $refresh_max_interval = undef,
  Optional[Knot::Subtypes::Time]                                        $retry_min_interval   = undef,
  Optional[Knot::Subtypes::Time]                                        $retry_max_interval   = undef,
  Optional[Knot::Subtypes::Time]                                        $expire_min_interval  = undef,
  Optional[Knot::Subtypes::Time]                                        $expire_max_interval  = undef,
  Optional[Enum['none', 'interpret', 'generate', 'member']]             $catalog_role         = undef,
  Optional[Array[String[1]]]                                            $catalog_template     = undef,
  Optional[Knot::Subtypes::Dname]                                       $catalog_zone         = undef,
  Optional[String[1]]                                                   $catalog_group        = undef,
  Optional[Array[String[1]]]                                            $module               = undef,
  Boolean                                                               $manage_zone          = false,
  Optional[String[1]]                                                   $zone_content_filter  = undef,
  Optional[Boolean]                                                     $zone_show_diff       = undef,
  Optional[Boolean]                                                     $zone_manage_records  = undef,
  Optional[String[1]]                                                   $zone_soa_ttl         = undef,
  Optional[String[1]]                                                   $zone_soa_class       = undef,
  Optional[String[1]]                                                   $zone_soa_mname       = undef,
  Optional[String[1]]                                                   $zone_soa_rname       = undef,
  Optional[String[1]]                                                   $zone_soa_refresh     = undef,
  Optional[String[1]]                                                   $zone_soa_retry       = undef,
  Optional[String[1]]                                                   $zone_soa_expire      = undef,
  Optional[String[1]]                                                   $zone_soa_minttl      = undef,
  Array[Knot::Record]                                                   $zone_records         = [],
  Array[String[1]]                                                      $zone_nameservers     = [],
  Integer                                                               $zone_nameservers_ttl = 3600,
  Hash[String[1],Knot::Subzone]                                         $zone_subzones        = {},
) {
  knot::add_conf { $domain:
    ensure                   => $ensure,
    zone                     => [
      'comment'              => $comment,
      'domain'               => $domain,
      'template'             => $template,
      'storage'              => $storage,
      'file'                 => $file,
      'zone-db-input'        => $zone_db_input,
      'zone-db-output'       => $zone_db_output,
      'master'               => $master,
      'ddns-master'          => $ddns_master,
      'notify'               => $send_notify,
      'notify-delay'         => $notify_delay,
      'update-delay'         => $update_delay,
      'acl'                  => $acl,
      'master-pin-tolerance' => $master_pin_tolerance,
      'provide-ixfr'         => $provide_ixfr,
      'semantic-checks'      => $semantic_checks,
      'default-ttl'          => $default_ttl,
      'zonefile-sync'        => $zonefile_sync,
      'zonefile-load'        => $zonefile_load,
      'zonefile-skip'        => $zonefile_skip,
      'journal-content'      => $journal_content,
      'journal-max-usage'    => $journal_max_usage,
      'journal-max-depth'    => $journal_max_depth,
      'ixfr-benevolent'      => $ixfr_benevolent,
      'ixfr-by-one'          => $ixfr_by_one,
      'ixfr-from-axfr'       => $ixfr_from_axfr,
      'zone-max-size'        => $zone_max_size,
      'adjust-threads'       => $adjust_threads,
      'external-validation'  => $external_validation,
      'dnssec-signing'       => $dnssec_signing,
      'dnssec-validation'    => $dnssec_validation,
      'dnssec-policy'        => $dnssec_policy,
      'ds-push'              => $ds_push,
      'zonemd-verify'        => $zonemd_verify,
      'zonemd-generate'      => $zonemd_generate,
      'serial-policy'        => $serial_policy,
      'serial-modulo'        => $serial_modulo,
      'reverse-generate'     => $reverse_generate,
      'include-from'         => $include_from,
      'refresh-min-interval' => $refresh_min_interval,
      'refresh-max-interval' => $refresh_max_interval,
      'retry-min-interval'   => $retry_min_interval,
      'retry-max-interval'   => $retry_max_interval,
      'expire-min-interval'  => $expire_min_interval,
      'expire-max-interval'  => $expire_max_interval,
      'catalog-role'         => $catalog_role,
      'catalog-template'     => $catalog_template,
      'catalog-zone'         => $catalog_zone,
      'catalog-group'        => $catalog_group,
      'module'               => $module,
    ],
  }
  if $manage_zone {
    knot_zone { $domain:
      zone_ensure    => $ensure,
      content_filter => $zone_content_filter,
      show_diff      => $zone_show_diff,
      manage_records => $zone_manage_records,
      soa_ttl        => $zone_soa_ttl,
      soa_class      => $zone_soa_class,
      soa_mname      => $zone_soa_mname,
      soa_rname      => $zone_soa_rname,
      soa_refresh    => $zone_soa_refresh,
      soa_retry      => $zone_soa_retry,
      soa_expire     => $zone_soa_expire,
      soa_minttl     => $zone_soa_minttl,
    }
  }
  if $manage_zone and $ensure == 'present' {
    $zone_records.each | Integer $i, Knot::Record $r | {
      knot_record { "record ${r['rname']}.${domain} (${i})":
        target_zone => $domain,
        rname       => $r.get('rname'),
        rclass      => $r.get('rclass'),
        rtype       => $r.get('rtype'),
        rttl        => $r.get('rttl'),
        rcontent    => $r.get('rcontent'),
      }
    }
    # add nameservers
    $zone_nameservers.each | String[1] $ns | {
      knot_record { "Nameserver: ${ns} for ${domain}":
        target_zone => $domain,
        rname       => '.',
        rtype       => 'NS',
        rttl        => $zone_nameservers_ttl,
        rcontent    => $ns,
      }
    }
    # add subzones
    $zone_subzones.each | String[1] $z, Knot::Subzone $sz | {
      pick_default($sz['nameservers'], []).each | String[1] $ns | {
        knot_record { "Subzone Nameserver: ${ns} for ${z}":
          target_zone => $domain,
          rname       => $z,
          rtype       => 'NS',
          rttl        => pick($sz['ttl'],$zone_nameservers_ttl),
          rcontent    => $ns,
        }
      }
      pick_default($sz['trust_ds'], []).each | String[1] $ds | {
        knot_record { "Subzone DS for ${z} (${ds})":
          target_zone => $domain,
          rname       => $z,
          rtype       => 'DS',
          rttl        => pick($sz['ttl'],$zone_nameservers_ttl),
          rcontent    => $ds,
        }
      }
    }
  }
}
