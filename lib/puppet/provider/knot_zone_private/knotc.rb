# frozen_string_literal: true

# This file contains a provider for the resource type `knot_zone_private`,
#
require 'tempfile'
Puppet::Type.type(:knot_zone_private).provide(
  :knotc
) do
  desc "A provider for the resource type `knot_zone`,
        which manages a zone on knot dns
        using the knotc command."

  commands knotc: 'knotc'

  def knotc_options
    []
  end

  def create; end

  def destroy
    knotc knotc_options, 'zone-purge', resource[:name]
  end

  def content=(content)
    return unless resource[:manage_records]

    # match soa record
    re_soa = %r{^[0-9]+ SOA .+ .+ _SERIAL_ [0-9]+ [0-9]+ [0-9]+ [0-9]+$}
    @serial ||= 0

    should_split = content.split("\n")
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
    "#{@records.sort.join("\n")}\n"
  end

  def exists?
    # knotc(knotc_options, 'zone-read', resource[:name]).split("\n").each do |line|
    #    return true if line == resource[:name]
    # end
    true
  end
end
