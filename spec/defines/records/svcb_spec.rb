# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::svcb' do
  let :default_params do
    { type: 'SVCB',
      ttl: 3600,
      svcb: [], }
  end

  shared_examples 'knot::records::svcb shared examples' do
    it { is_expected.to compile.with_all_deps }

    it {
      i = 0
      params[:svcb].each do |_v|
        is_expected.to contain_knot_record("svcb for #{title} (#{i})")
          .with_target_zone(params[:target_zone])
          .with_rname(params[:rname])
          .with_rttl(params[:ttl])
          .with_rtype(params[:type])
        i += 1
      end
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(target_zone: 'example.org', rname: '.')
        end

        it_behaves_like 'knot::records::svcb shared examples'
      end

      context 'with non defaults' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(target_zone: 'example.org',
                               rname: 'hostname',
                               type: 'HTTPS',
                               svcb: [{ 'alpn' => ['h2'], 'ipv4hint' => ['127.0.0.1'] }])
        end

        it_behaves_like 'knot::records::svcb shared examples'
      end
    end
  end
end
