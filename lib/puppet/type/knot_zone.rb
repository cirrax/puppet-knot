# frozen_string_literal: true

require 'puppet/parameter/boolean'

Puppet::Type.newtype(:knot_zone) do
  @doc = 'ensure a zone exists. The zone is managed using the
         resource knot_zone_private'

  newparam(:name, namevar: true) do
    desc 'name of the zone name as namevar'

    validate do |value|
      raise ArgumentError, 'The name of the zone needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:zone_ensure) do
    desc 'ensure parameter for the zone, use present/absent'
    defaultto 'present'
  end

  newparam(:content_filter) do
    desc 'regex for filtering out unwanted records by default filters dnssec records and zonemd, assuming you use autogeneration'
    defaultto '^.+ [0-9]+ (RRSIG|NSEC|DNSKEY|CDNSKEY|CDS|ZONEMD) .*$'
    validate do |value|
      raise ArgumentError, 'content_filter needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:show_diff, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc "Whether to display differences when the zone changes, defaulting to
        false. Since zones can be huge, use this only for debugging"
    defaultto :false
  end

  newparam(:manage_records, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'If puppet shall manage all zone records for the domain (any records not managed with puppet will be purged).
         The default is true, to manage the SOA record and all zone records through puppet for the zone.
         If set to false, ensurance of zone creation is done only and the administration of zone records needs to be done through
         web Interface or any other preferred method.
         '
    defaultto :true
  end

  newparam(:soa_ttl) do
    desc 'ttl for SOA record'
    defaultto '3600'
    validate do |value|
      raise ArgumentError, 'soa_ttl needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:soa_class) do
    desc 'zone class for SOA record'
    defaultto 'IN'
    validate do |value|
      raise ArgumentError, 'soa_class needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:soa_mname) do
    desc 'primary master name server for the zone for SOA record'
    # defaultto { @resource[:name] }
    defaultto { "ns.#{resource[:name]}." }
    validate do |value|
      raise ArgumentError, 'soa_mname needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:soa_rname) do
    desc 'Email address of the administrator responsible for this zone for SOA record'
    defaultto { "hostmaster.#{resource[:name]}." }
    validate do |value|
      raise ArgumentError, 'soa_rname needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:soa_refresh) do
    desc 'Number of seconds after which secondary name servers should query the master for the SOA record, to detect zone changes'
    defaultto '10800'
    validate do |value|
      raise ArgumentError, 'soa_refresh needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:soa_retry) do
    desc 'Number of seconds after which secondary name servers should retry to request the serial number from the master if the master does not respond'
    defaultto '3600'
    validate do |value|
      raise ArgumentError, 'soa_retry needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:soa_expire) do
    desc 'Number of seconds after which secondary name servers should stop answering request for this zone if the master does not respond.'
    defaultto '604800'
    validate do |value|
      raise ArgumentError, 'soa_expire needs to be a string' unless value.is_a?(String)
    end
  end

  newparam(:soa_minttl) do
    desc 'Minimum ttl in seconds, negativ response caching ttl'
    defaultto '3600'
    validate do |value|
      raise ArgumentError, 'soa_minttl needs to be a string' unless value.is_a?(String)
    end
  end

  def soa_record
    # create the soa record and set serial to +1 since we want to increase anyway
    soa = [self['soa_mname'], self['soa_rname'], '_SERIAL_', self['soa_refresh'], self['soa_retry'], self['soa_expire'], self['soa_minttl']].join(' ')
    [self['soa_ttl'], 'SOA', soa].join(' ')
  end

  def records
    # Collect records that target this zone.
    @records ||= catalog.resources.map do |resource|
      next unless resource.is_a?(Puppet::Type.type(:knot_record))

      resource if resource[:target_zone] == title
    end.compact
  end

  def should_content
    # collect and sort all records for content
    content = [].push(soa_record)

    records.each do |r|
      if r[:rname] == '.'
        content.push(["#{r[:target_zone]}.", r[:rttl], r[:rclass], r[:rtype], r[:rcontent]].join(' ').gsub(%r{  }, ' '))
      else
        content.push(["#{r[:rname]}.#{r[:target_zone]}.", r[:rttl], r[:rclass], r[:rtype], r[:rcontent]].join(' ').gsub(%r{  }, ' '))
      end
    end
    content.sort.join("\n")
  end

  def generate
    # create the knot_zone_private resource as a copy of this resource
    # without content
    knot_zone_private_opts = {}

    %i[name
       content_filter
       show_diff
       manage_records].each do |p|
      knot_zone_private_opts[p] = self[p] unless self[p].nil?
    end
    knot_zone_private_opts['ensure'] = self['zone_ensure']

    excluded_metaparams = %i[before notify require subscribe tag]

    Puppet::Type.metaparams.each do |metaparam|
      knot_zone_private_opts[metaparam] = self[metaparam] unless self[metaparam].nil? || excluded_metaparams.include?(metaparam)
    end

    [Puppet::Type.type(:knot_zone_private).new(knot_zone_private_opts)]
  end

  def eval_generate
    # add the content to the knot_zone_private resource containing
    # ower on content and the content of the matching knot_record resources
    content = should_content
    catalog.resource("Knot_zone_private[#{self[:name]}]")[:content] = content

    [catalog.resource("Knot_zone_private[#{self[:name]}]")]
  end

  # autorequire the knot class
  autorequire(:service) do
    ['knot']
  end

  # autorequire the knot_records
  autorequire(:knot_record) do
    # placeholder
  end
end
