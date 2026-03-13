# @summary export sshfp keys for inclusion in dns
#
# @param domains
#   the domains we export the host for
#   for each domain we export a setting
#   with "${hname}.${domain}"
# @param hname
#   the hostname we export for each of the domain
# @param additional_fqdn
#   Tuples of hostname, domain of additional fqdns we export 
# @param fingerprints
#   fingerprints to export
#   if unset, we take the values from the ssh fact
# @param selector
#   tag to set, let's you filter the import
#   the tag is combined with the domain
# @param ttl
#   the ttl to set
#
class knot::records::sshfp::export (
  Array[String[1]]           $domains                 = [$facts['networking']['domain']],
  String[1]                  $hname                   = $facts['networking']['hostname'],
  Array[Tuple[String[1], String[1]]] $additional_fqdn = [],
  Optional[Array[String[1]]] $fingerprints            = undef,
  String[1]                  $selector                = 'knot-sshfp',
  Integer                    $ttl                     = 3600,
) {
  if $fingerprints {
    $_fingerprints = $fingerprints
  } else {
    # facts structure: { 'keytype' => { 'fingerprints' => { 'digest' => 'SSFP X Y bla' }}}
    $_fingerprints = $facts['ssh'].reduce([]) | $memo, $value | { $memo + $value[1]['fingerprints'].map | $k, $v | { $v.regsubst(/^SSHFP */, '') } }
  }

  $domains.each | String[1] $dom | {
    $_fingerprints.each | String[1] $fp | {
      @@knot_record { "sshfp for ${hname}.${dom} (${fp})":
        target_zone => $dom,
        rname       => $hname,
        rttl        => $ttl,
        rtype       => 'SSHFP',
        rcontent    => $fp.upcase(),
        tag         => "${selector}_${dom}",
      }
    }
  }

  $additional_fqdn.each | Tuple[String[1], String[1]] $afqdn | {
    $_fingerprints.each | String[1] $fp | {
      @@knot_record { "sshfp for ${afqdn[0]}.${afqdn[1]} (${fp})":
        target_zone => $afqdn[1],
        rname       => $afqdn[0],
        rttl        => $ttl,
        rtype       => 'SSHFP',
        rcontent    => $fp.upcase(),
        tag         => "${selector}_${afqdn[1]}",
      }
    }
  }
}
