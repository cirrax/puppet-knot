# additional config files to add to knot
# eg for zones
#
# @param ensure
# @param module
#   Dynamic modules loading configuration.
# @param server
#   General options related to the server.
# @param xdp
#   Various options related to XDP listening, especially TCP.
# @param control
#   Configuration of the server control interface.
# @param log
#   Logging options
# @param statistics
#   Periodic server statistics dumping
# @param database
#   Configuration of databases for zone contents, 
#   DNSSEC metadata, or event timers.
# @param keystore
#   DNSSEC keystore configuration.
# @param key
#   Shared TSIG keys used to authenticate
#   communication with the server.
# @param remote
#   Definitions of remote servers for outgoing connections
# @param remotes
#   Definitions of groups of remote servers
# @param acl
#   Access control list rule definitions
# @param submission
#   Parameters of KSK submission checks.
# @param dnskey_sync
#   Parameters of DNSKEY dynamic-update synchronization.
# @param policy
#   DNSSEC policy configuration.
# @param external
#   External zone validation configuration
# @param template
#   shareable zone settings
# @param zone
#   Definition of zones served by the server
# @param clear
#   Array of parameter matches to clear 
#   (set at the beginning of the file, after first_includes)
# @param first_includes
#   Array of includes files, globs to include into the config
#   (set at the very beginning of the file)
# @param last_includes
#   Array of includes files, globs to include into the config
#   (set at the very end of the file)
# @param params
#   the parameter names we print (if not undef) into the
#   config file.
#   see data/common.yaml for the default value
# @param index_elements
#   for certain parameters an index element exist which
#   is mandatory and needs to be printed before all
#   other elements.
#   these index are defined as a Hash where the key
#   is the parameter name, and the value the key in
#   the parameter Hash !
#   see data/common.yaml for the default value
# @param config_dir
#   the directory where to put this configuration file
#   defaults to config_dir set in init.pp
# @param filename
#   the filename to write, default "${title}.conf"
#
define knot::add_conf (
  Enum['present', 'absent']           $ensure         = 'present',
  Hash[String[1],Knot::Module]        $module         = {},
  Optional[Knot::Server]              $server         = undef,
  Optional[Knot::Xdp]                 $xdp            = undef,
  Optional[Knot::Control]             $control        = undef,
  Optional[Array[Knot::Log]]          $log            = undef,
  Optional[Knot::Statistics]          $statistics     = undef,
  Optional[Knot::Database]            $database       = undef,
  Optional[Array[Knot::Keystore]]     $keystore       = undef,
  Optional[Array[Knot::Key]]          $key            = undef,
  Optional[Array[Knot::Remote]]       $remote         = undef,
  Optional[Array[Knot::Remotes]]      $remotes        = undef,
  Optional[Array[Knot::Acl]]          $acl            = undef,
  Optional[Array[Knot::Submission]]   $submission     = undef,
  Optional[Array[Knot::Dnskey_sync]]  $dnskey_sync    = undef,
  Optional[Array[Knot::Policy]]       $policy         = undef,
  Optional[Array[Knot::External]]     $external       = undef,
  Optional[Array[Knot::Template]]     $template       = undef,
  Optional[Array[Knot::Zone]]         $zone           = undef,
  Array[String[1]]                    $clear          = [],
  Array[String[1]]                    $first_includes = [],
  Array[String[1]]                    $last_includes  = [],
  Optional[Array[String[1]]]          $params         = undef,
  Optional[Hash[String[1],String[1]]] $index_elements = undef,
  Optional[Stdlib::Absolutepath]      $config_dir     = undef,
  String[1]                           $filename       = "${title}.conf",
) {
  include knot

  $_config_dir = pick($config_dir, $knot::config_dir)

  if $ensure == 'present' {
    $_ensure = 'file'
  } else {
    $_ensure = 'absent'
  }

  file { "${_config_dir}/${filename}":
    ensure  => $_ensure,
    owner   => $knot::owner,
    group   => $knot::group,
    mode    => $knot::mode,
    content => epp('knot/knot.conf.epp', {
      params         => pick($params, $knot::params),
      index_elements => pick($index_elements, $knot::index_elements),
      module         => $module,
      server         => $server,
      xdp            => $xdp,
      control        => $control,
      log            => $log,
      statistics     => $statistics,
      database       => $database,
      keystore       => $keystore,
      key            => $key,
      remote         => $remote,
      remotes        => $remotes,
      acl            => $acl,
      submission     => $submission,
      dnskey_sync    => $dnskey_sync,
      policy         => $policy,
      external       => $external,
      template       => $template,
      zone           => $zone,
      clear          => $clear,
      first_includes => $first_includes,
      last_includes  => $last_includes,
    }),
    notify  => Service['knot'],
  }
}
