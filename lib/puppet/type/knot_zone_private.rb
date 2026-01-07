# frozen_string_literal: true

# private resource which collected all the records through knot_zone
require 'puppet/parameter/boolean'

Puppet::Type.newtype(:knot_zone_private) do
  @doc = 'ensure a zone exists. This is a private class do NOT use it in your mannifests instead use knot_zone which will
         call this resource with the zone records added.'

  ensurable do
    desc 'Whether the zone should be present or absent'
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'name of the zone name as namevar'

    validate do |value|
      raise ArgumentError, 'The name of the zone needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:content_filter) do
    desc 'regex for filtering out unwanted records by default filters dnssec records assuming you use autosigning'
    defaultto '^.+ [0-9]+ (RRSIG|NSEC|DNSKEY|CDNSKEY|CDS) .*$'
    validate do |value|
      raise ArgumentError, 'content_filter needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:manage_records, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'if we manage the all zone records for the domain (any records not managed with puppet will be purged).'
    defaultto :true
  end

  newparam(:show_diff, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc "Whether to display differences when the zone changes, defaulting to
        false. Since zones can be huge, use this only for debugging"
    defaultto :false
  end

  newproperty(:content) do
    desc "Content (records) of the zone. This must match the output of 'knotc zone-read ZONE|sort'."

    munge do |value|
      if @resource[:manage_records]
        "#{value.to_s.gsub(%r{\n+$}, '')}\n"
      else
        ''
      end
    end

    def change_to_s(current, desire)
      if @resource[:show_diff]
        ['', ((desire.split(%r{\n+}) - current.split(%r{\n+})).map { |k| "#{k}+" } +
        (current.split(%r{\n+}) - desire.split(%r{\n+})).map { |k| "#{k}-" }).sort.map { |k| " #{k[-1]} #{k[0..-2]} " }, ''].join("\n")
      else
        "{md5}#{Digest::MD5.hexdigest(current.to_s)} to: {md5}#{Digest::MD5.hexdigest(desire.to_s)}"
      end
    end
  end

  # autorequire the knot class
  autorequire(:service) do
    ['knot']
  end
  autorequire(:knot_zone) do
    # placeholder
  end
end
