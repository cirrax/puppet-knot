# frozen_string_literal: true

require 'ipaddr'

#
# @summary
#   calculate the host part for a reverse PTR record
#
Puppet::Functions.create_function(:'knot::reverse4_host') do
  # @param ipaddress
  #   the ip address we like to create the reverse record
  # @param parts
  #  set the parts to taken for the hostname.
  #  eg. setting split = 1 for ip 1.2.3.4 results in
  #  returning host part 4
  # @return [String[1]] the host
  #
  # @example
  #   knot::reverse4_host('1.2.3.4',2) => '4.3'
  #
  dispatch :reverse4_host do
    param 'Stdlib::IP::Address::V4::Nosubnet', :ipaddress
    param 'Integer[1,4]', :parts
    return_type 'String[1]'
  end

  def reverse4_host(ipaddress, parts)
    IPAddr.new(ipaddress).reverse.to_s.split('.').first(parts).join('.')
  end
end
