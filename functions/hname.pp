#
# function to get the hostname of fqdn
# by cutting the zone
#
# @param thefqdn
#   the fqdn of a node
# @return
#   the hostname of the fqdn (cuts the zone)
#   for toplevel domains we return a '.'
# 
function knot::hname(
  String $thefqdn,
) {
  $res = $thefqdn.split('\.')
  if $res.length() > 2 {
    $res[0]
  } else {
    '.'
  }
}
