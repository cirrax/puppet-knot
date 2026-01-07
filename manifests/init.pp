# main class to configure knot dns
#
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
# @param service_name
#   name of the knot service
# @param service_ensure
#   what to ensure for the service
# @param service_enable
#   if the service should be enabled
# @param packages
#   knot packages to install
# @param config_file
#   name of the config file
# @param config_dir
#   directory for additional include files
#   created with puppet
# @param owner
#   owner of the config file(s)
# @param group
#   group of the config file(s)
# @param mode
#   mode of the config file(s)
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
# @param domains
#   domains to create using the define knot::domain.
#   see there for parameters to use per domain.
#   Remark: this parameter is hiera hash merged.
#
class knot (
  Hash[String[1],Knot::Module]           $module         = {},
  Optional[Knot::Server]                 $server         = undef,
  Optional[Knot::Xdp]                    $xdp            = undef,
  Optional[Knot::Control]                $control        = undef,
  Optional[Array[Knot::Log]]             $log            = undef,
  Optional[Knot::Statistics]             $statistics     = undef,
  Optional[Knot::Database]               $database       = undef,
  Optional[Array[Knot::Keystore]]        $keystore       = undef,
  Optional[Array[Knot::Key]]             $key            = undef,
  Optional[Array[Knot::Remote]]          $remote         = undef,
  Optional[Array[Knot::Remotes]]         $remotes        = undef,
  Optional[Array[Knot::Acl]]             $acl            = undef,
  Optional[Array[Knot::Submission]]      $submission     = undef,
  Optional[Array[Knot::Dnskey_sync]]     $dnskey_sync    = undef,
  Optional[Array[Knot::Policy]]          $policy         = undef,
  Optional[Array[Knot::External]]        $external       = undef,
  Optional[Array[Knot::Template]]        $template       = undef,
  Optional[Array[Knot::Zone]]            $zone           = undef,
  Array[String[1]]                       $clear          = [],
  Array[String[1]]                       $first_includes = [],
  Array[String[1]]                       $last_includes  = ['/etc/knot/conf.d/*.conf'],
  String[1]                              $service_name   = 'knot',
  String[1]                              $service_ensure = 'running',
  Boolean                                $service_enable = true,
  Array[String[1]]                       $packages       = ['knot', 'knot-keymgr'],
  Stdlib::Absolutepath                   $config_file    = '/etc/knot/knot.conf',
  Stdlib::Absolutepath                   $config_dir     = '/etc/knot/conf.d',
  String[1]                              $owner          = 'root',
  String[1]                              $group          = 'knot',
  String[1]                              $mode           = '0640',
  Array[String[1]]                       $params         = [],
  Hash[String[1],String[1]]              $index_elements = {},
  Hash[String[1],Hash]                   $domains        = {},
) {
  package { $packages :
    ensure => 'installed',
    before => [
      File[$config_dir],
      File[$config_file],
    ],
  }

  service { 'knot':
    ensure => $service_ensure,
    name   => $service_name,
    enable => $service_enable,
  }

  file { $config_dir:
    ensure  => 'directory',
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    recurse => true,
    purge   => true,
  }

  file { $config_file:
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => epp('knot/knot.conf.epp', {
      params         => $params,
      index_elements => $index_elements,
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

  $domains.each |String[1] $domain, Hash $vals| {
    knot::domain { $domain:
      * => $vals,
    }
  }
}
