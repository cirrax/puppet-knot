# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::tlsa' do
  let :default_params do
    { ttl: 3600,
      tlsa: [],
      service: [], }
  end

  shared_examples 'knot::records::tlsa shared examples' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('knot::records::defaults::tlsa') }

    it {
      i = 0
      params[:service].each do |serv|
        params[:tlsa].each do |v|
          if params[:rname] == '.'
            is_expected.to contain_knot_record("tlsa (#{serv[:port]}, #{serv[:proto]}): #{title} (#{i})")
              .with_target_zone(params[:target_zone])
              .with_rname("_#{serv[:port]}._#{serv[:proto]}")
              .with_rttl(params[:ttl])
              .with_rtype('TLSA')
              .with_rcontent("#{v[:usage]} #{v[:selector]} #{v[:matching]} #{v[:value].upcase}")
          else
            is_expected.to contain_knot_record("tlsa (#{serv[:port]}, #{serv[:proto]}): #{title} (#{i})")
              .with_target_zone(params[:target_zone])
              .with_rname("_#{serv[:port]}._#{serv[:proto]}.#{params[:rname]}")
              .with_rttl(params[:ttl])
              .with_rtype('TLSA')
              .with_rcontent("#{v[:usage]} #{v[:selector]} #{v[:matching]} #{v[:value].upcase}")
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

        it_behaves_like 'knot::records::tlsa shared examples'
      end

      context 'with record for host' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(
            target_zone: 'example.org',
            tlsa: [{ usage: 3, selector: 1, matching: 1, value: 'abc34' }],
            service: [{ port: 111, proto: 'tcp' }],
            rname: 'test'
          )
        end

        it_behaves_like 'knot::records::tlsa shared examples'
      end

      context 'with record for domain' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(
            target_zone: 'example.org',
            tlsa: [{ usage: 3, selector: 1, matching: 1, value: 'abc34' }],
            service: [{ port: 111, proto: 'tcp' }],
            rname: '.'
          )
        end

        it_behaves_like 'knot::records::tlsa shared examples'
      end
    end
  end
end
