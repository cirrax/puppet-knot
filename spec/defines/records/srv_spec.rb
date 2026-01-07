# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::srv' do
  let :default_params do
    { ttl: 3600,
      srv: [],
      service: [], }
  end

  shared_examples 'knot::records::srv shared examples' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('knot::records::defaults::srv') }

    it {
      i = 0
      params[:service].each do |serv|
        params[:srv].each do |v|
          if params[:rname] == '.'
            is_expected.to contain_knot_record("srv (#{serv[:port]}, #{serv[:proto]}): #{title} (#{i})")
              .with_target_zone(params[:target_zone])
              .with_rname("_#{serv[:port]}._#{serv[:proto]}")
              .with_rttl(params[:ttl])
              .with_rtype('SRV')
              .with_rcontent("#{v[:priority]} #{v[:weight]} #{v[:target_port]} #{v[:target]}")
          else
            is_expected.to contain_knot_record("srv (#{serv[:port]}, #{serv[:proto]}): #{title} (#{i})")
              .with_target_zone(params[:target_zone])
              .with_rname("_#{serv[:port]}._#{serv[:proto]}.#{params[:rname]}")
              .with_rttl(params[:ttl])
              .with_rtype('SRV')
              .with_rcontent("#{v[:priority]} #{v[:weight]} #{v[:target_port]} #{v[:target]}")
          end
          i += 1
        end
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

        it_behaves_like 'knot::records::srv shared examples'
      end

      context 'with record for host' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(
            target_zone: 'example.org',
            srv: [{ priority: 10, weight: 10, target_port: 10, target: 'test.test.com' }],
            service: [{ port: 111, proto: 'tcp' }],
            rname: 'test'
          )
        end

        it_behaves_like 'knot::records::srv shared examples'
      end

      context 'with record for domain' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(
            target_zone: 'example.org',
            srv: [{ priority: 10, weight: 10, target_port: 10, target: 'test.test.com' }],
            service: [{ port: 111, proto: 'tcp' }],
            rname: '.'
          )
        end

        it_behaves_like 'knot::records::srv shared examples'
      end
    end
  end
end
