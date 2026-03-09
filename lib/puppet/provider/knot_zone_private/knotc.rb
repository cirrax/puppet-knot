# frozen_string_literal: true

# This file contains a provider for the resource type `knot_zone_private`,
#
require 'tempfile'
Puppet::Type.type(:knot_zone_private).provide(
  :knotc
) do
  desc "A provider for the resource type `knot_zone`,
        which manages a zone on knot dns
        using the knotc and keymgr command."

  commands knotc: 'knotc'
  commands keymgr: 'keymgr'

  def knotc_options
    []
  end

  def glue_records
    # get the CDS and NS records for all specified subdomains
    records = []
    resource[:local_subzones].each do |subzone|
      begin
        r = keymgr(subzone, 'ds')
      rescue StandardError
        # ignore if no keys are available for zone
      else
        records += r.split("\n").map do |c|
          "#{subzone} 3600 DS #{c.gsub(%r{^.* DS }, '').upcase}"
        end
      end

      begin
        r = knotc(knotc_options, 'zone-read', subzone, subzone, 'NS')
      rescue StandardError
        # ignore if no NS are available for zone (or zone not available)
      else
        records += r.split("\n").map do |c|
          c.gsub(%r{^\[#{subzone}\] }, '')
        end
      end
    end
    records
  end

  def create; end

  def destroy
    knotc knotc_options, 'zone-purge', resource[:name]
    keymgr(resource[:name], list).split("\n").each do |k|
      keymgr resource[:name], 'delete', k.split[0]
    end
  end

  def content=(content)
    return unless resource[:manage_records]

    # match soa record
    re_soa = %r{^[0-9]+ SOA .+ .+ _SERIAL_ [0-9]+ [0-9]+ [0-9]+ [0-9]+$}
    @serial ||= 0

    should_split = (content.split("\n") - ['changing glue records']) + glue_records
    begin
      knotc(knotc_options, 'zone-begin', resource[:name])
      (@records - should_split).each do |r|
        x = r.split
        knotc(knotc_options, 'zone-unset', resource[:name], x[0], x[1..]) unless re_soa.match(r)
      end
      (should_split - @records).each do |r|
        if re_soa.match(r)
          knotc(knotc_options, 'zone-set', resource[:name], '@', r.gsub(%r{_SERIAL_}, (@serial.to_i + 1).to_s))
        else
          x = r.split
          knotc(knotc_options, 'zone-set', resource[:name], x[0], x[1..])
        end
      end
      knotc(knotc_options, 'zone-commit', resource[:name])
    rescue Puppet::Error => e
      knotc(knotc_options, 'zone-abort', "#{resource[:name]}.")
      raise Puppet::Error, "update of knot using knotc failed (aborted any open session) #{e}"
    end

    # we already incremented serial above. if unixtime is specified, we continue to set
    return unless resource[:serial_policy].to_s == 'unixtime'

    begin
      knotc(knotc_options, 'zone-serial-set', "#{resource[:name]}.", Time.now.to_i)
    rescue Puppet::Error
      # we already incremented above, so we can ignore
    end
  end

  def content
    return '' unless resource[:manage_records]

    re_soa = %r{^.+ [0-9]+ SOA .+ .+ [0-9]+ [0-9]+ [0-9]+ [0-9]+ [0-9]+$}
    # re_filter = %r{^.+ [0-9]+ (RRSIG|NSEC|DNSKEY|CDNSKEY|CDS) .*$}
    re_filter = %r{#{resource[:content_filter]}}
    c = knotc(knotc_options, 'zone-read', resource[:name])
    @records = (c.split("\n").map do |s|
      s = s.gsub(%r{^\[#{resource[:name]}.\] }, '')
      if re_soa.match(s)
        @serial = s.gsub(%r{^.+ [0-9]+ SOA .+ .+ ([0-9]+) [0-9]+ [0-9]+ [0-9]+ [0-9]+$}, '\1')
        s.gsub(%r{^.+ ([0-9]+ SOA .+ .+) [0-9]+ ([0-9]+ [0-9]+ [0-9]+ [0-9]+)$}, '\1 _SERIAL_ \2')
      elsif !re_filter.match(s)
        s
      end
    end).compact
    glues = glue_records
    if (glues & @records) == glues
      "#{(@records - glues).sort.join("\n")}\n"
    else
      "#{((@records - glues) + ['changing glue records']).sort.join("\n")}\n"
    end
  end

  def exists?
    re_match = %r{^\[#{resource[:name]}.\]}
    knotc(knotc_options, 'zone-status').split("\n").each do |line|
      return true if re_match.match(line)
    end
    false
  end
end
