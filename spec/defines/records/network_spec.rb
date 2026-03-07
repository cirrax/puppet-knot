# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::network' do
  let :default_params do
    { ttl: 3600,
      hostlist: {},
      ipv4_key: 'ipv4',
      ipv6_key: 'ipv6', }
  end

  shared_examples 'knot::records::network shared examples' do
    it { is_expected.to compile.with_all_deps }

    it {
      params[:hostlist].each do |rname, vals|
        next if vals[:"#{params[:ipv4_key]}"].nil?

        is_expected.to contain_knot_record("ipv4: #{title} #{rname}.#{params[:target_zone]}")
          .with_target_zone(params[:target_zone])
          .with_rname(rname.downcase)
          .with_rtype('A')
          .with_rttl(params[:ttl])
          .with_rcontent(vals[:"#{params[:ipv4_key]}"])
        next if params[:rev4_target_split].nil?

        is_expected.to contain_knot_record("ipv4 reverse: #{title} for #{rname}.#{params[:target_zone]}")
          .with_rtype('PTR')
          .with_rttl(params[:ttl])
          .with_rcontent("#{rname}.#{params[:target_zone]}.")
      end
    }

    it {
      params[:hostlist].each do |rname, vals|
        next if vals[:"#{params[:ipv6_key]}"].nil?

        is_expected.to contain_knot_record("ipv6: #{title} #{rname}.#{params[:target_zone]}")
          .with_target_zone(params[:target_zone])
          .with_rname(rname.downcase)
          .with_rtype('AAAA')
          .with_rttl(params[:ttl])
          .with_rcontent(vals[:"#{params[:ipv6_key]}"])
        next if params[:rev6_target_split].nil?

        is_expected.to contain_knot_record("ipv6 reverse: #{title} for #{rname}.#{params[:target_zone]}")
          .with_rtype('PTR')
          .with_rttl(params[:ttl])
          .with_rcontent("#{rname}.#{params[:target_zone]}.")
      end
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(target_zone: 'example.org')
        end

        it_behaves_like 'knot::records::network shared examples'
      end

      context 'with non defaults defaults' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(
            target_zone: 'example.org',
            hostlist: { 'host' => { ipv4: '1.1.1.1', ipv6: '::1' } },
            rev4_target_split: 1,
            rev6_target_split: 21
          )
        end

        it_behaves_like 'knot::records::network shared examples'
      end
    end
  end
end
