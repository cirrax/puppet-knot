# frozen_string_literal: true

require 'ipaddr'

#
# @summary
#   calculate the target domain for a reverse PTR record
#
Puppet::Functions.create_function(:'knot::reverse6_host') do
  # @param ipaddress
  #   the ip address we like to create the reverse record
  # @param parts
  #  set the parts to take for the hostname.
  #  eg. setting split = 1 for ip ::1 results in
  #  returning host 1
  # @return [String[1]] the host
  #
  # @example
  #  knot::reverse6_host('::1',2) => '1.0'
  #
  dispatch :reverse6_host do
    param 'Stdlib::IP::Address::V6::Nosubnet', :ipaddress
    param 'Integer[1,32]', :parts
    return_type 'String[1]'
  end

  def reverse6_host(ipaddress, parts)
    IPAddr.new(ipaddress).reverse.to_s.split('.').first(parts).join('.')
  end
end
