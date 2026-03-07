# frozen_string_literal: true

require 'ipaddr'

#
# @summary
#   calculate the target domain for a reverse PTR record
#
Puppet::Functions.create_function(:'knot::reverse6_target') do
  # @param ipaddress
  #   the ip address we like to create the reverse record
  # @param parts
  #  set the parts taken away for the hostname.
  #  eg. setting parts = 1 for ip ::1 results in
  #  returning target zone
  #  0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa
  # @return [String[1]] the target domain
  #
  # @example
  #  knot::reverse6_target('::1',21) => '0.0.0.0.0.0.0.d.c.b.a.ip6.arpa'
  #
  dispatch :reverse6_target do
    param 'Stdlib::IP::Address::V6::Nosubnet', :ipaddress
    param 'Integer[1,32]', :parts
    return_type 'String[1]'
  end

  def reverse6_target(ipaddress, parts)
    IPAddr.new(ipaddress).reverse.to_s.split('.').last(34 - parts).join('.')
  end
end
