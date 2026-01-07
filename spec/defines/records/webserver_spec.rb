# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::webserver' do
  let :default_params do
    { ttl: 3600,
      alpn: [],
      caa: [],
      tlsa: [],
      tlsa_service: [], }
  end

  shared_examples 'knot::records::webserver shared examples' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('knot::records::defaults::webserver') }

    it {
      if params[:ipv4]
        is_expected.to contain_knot_record("ipv4: #{title}")
          .with_target_zone(params[:target_zone])
          .with_rname(params[:rname])
          .with_rtype('A')
          .with_rttl(params[:ttl])
          .with_rcontent(params[:ipv4])
      end
    }

    it {
      if params[:ipv6]
        is_expected.to contain_knot_record("ipv6: #{title}")
          .with_target_zone(params[:target_zone])
          .with_rname(params[:rname])
          .with_rtype('AAAA')
          .with_rttl(params[:ttl])
          .with_rcontent(params[:ipv6])
      end
    }

    it {
      is_expected.to contain_knot__records__caa("webserver CAA #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_caa(params[:caa])
    }

    it {
      is_expected.to contain_knot__records__tlsa("webserver TLSA #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_tlsa(params[:tlsa])
        .with_service(params[:tlsa_service])
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let(:title) { 'example.org' }
        let :params do
          default_params.merge(target_zone: 'example.org', rname: '.')
        end

        it_behaves_like 'knot::records::webserver shared examples'
      end

      context 'with all set' do
        let(:title) { 'example.org' }
        let :params do
          default_params.merge(
            target_zone: 'example.org',
            rname: 'www',
            ipv4: '1.1.1.1',
            ipv6: '::42',
            alpn: ['h2'],
            ttl: 4242,
            caa: [{ 'flags' => 0, 'tag' => 'issue', 'value' => 'letsencrypt.org' }],
            tlsa: [{ 'usage' => 3, 'selector' => 1, 'matching' => 1, 'value' => 'abc34' }],
            tlsa_service: [{ 'port' => 443, 'proto' => 'tcp' }]
          )
        end

        it_behaves_like 'knot::records::webserver shared examples'
      end
    end
  end
end
