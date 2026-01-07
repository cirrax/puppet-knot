#
# function to get the zone of fqdn
# by cutting the hostname
#
# @param thefqdn
#   the fqdn of a node
# @return
#   the zone of the fqdn (cuts the hostname)
#   if the resulting zone is a top level zone, we return $thefqdn
# 
function knot::zone(
  String $thefqdn,
) {
  # $res=$thefqdn.split('\.')[1,-1].join('.')
  $res=$thefqdn.split('\.')
  if $res.length() > 2 {
    $res[1,-1].join('.')
  } else {
    $thefqdn
  }
}
