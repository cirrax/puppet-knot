# @summary import exported sshfp records
#
# @param domains
#   the domains we import
#   note: without setting nothing will be imported !
# @param selector
#   the tag we import
#   
class knot::records::sshfp::import (
  Array[String[1]] $domains  = ['int.cirrax.com'],
  String[1]        $selector = 'knot-sshfp',
) {
  $domains.each | String[1] $dom | {
    Knot_record<| tag == "${selector}_${dom}" |>
  }
}
