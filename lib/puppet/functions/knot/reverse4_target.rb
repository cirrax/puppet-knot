# frozen_string_literal: true

require 'ipaddr'

#
# @summary
#   calculate the target domain for a reverse PTR record
#
Puppet::Functions.create_function(:'knot::reverse4_target') do
  # @param ipaddress
  #   the ip address we like to create the reverse record
  # @param parts
  #  set the parts taken away for the hostname.
  #  eg. setting split = 1 for ip 1.2.3.4 results in
  #  returning target zone 3.2.1.in-addr.arpa
  # @return [String[1]] the target domain
  #
  # @example
  #  knot::reverse4_target('1.2.3.4',2) => 2.1.in-addr.arpa
  #
  dispatch :reverse4_target do
    param 'Stdlib::IP::Address::V4::Nosubnet', :ipaddress
    param 'Integer[1,4]', :parts
    return_type 'String[1]'
  end

  def reverse4_target(ipaddress, parts)
    IPAddr.new(ipaddress).reverse.to_s.split('.').last(6 - parts).join('.')
  end
end
