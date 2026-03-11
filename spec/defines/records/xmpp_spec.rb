# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::xmpp' do
  let :default_params do
    {
      xmpp_client: [{ 'priority' => 0, 'weight' => 5, 'target_port' => 5222 }],
      xmpp_client_service: [{ 'port' => 'xmpp-client', 'proto' => 'tcp' }],
      xmpps_client: [{ 'priority' => 0, 'weight' => 5, 'target_port' => 5223 }],
      xmpps_client_service: [{ 'port' => 'xmpps-client', 'proto' => 'tcp' }],
      xmpp_server: [{ 'priority' => 0, 'weight' => 5, 'target_port' => 5269 }],
      xmpp_server_service: [{ 'port' => 'xmpp-server', 'proto' => 'tcp' }],
      xmpps_server: [{ 'priority' => 0, 'weight' => 5, 'target_port' => 5270 }],
      xmpps_server_service: [{ 'port' => 'xmpps-server', 'proto' => 'tcp' }],
      tlsa: [],
      ttl: 3600,
    }
  end

  shared_examples 'knot::records::xmpp shared examples' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('knot::records::defaults::xmpp') }

    it {
      is_expected.to contain_knot__records__srv("SRV xmpp-client #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_srv(params[:xmpp_client].map { |item| item.merge({ target: params[:dest_target] }) })
        .with_service(params[:xmpp_client_service])
        .with_ttl(params[:ttl])
    }

    it {
      is_expected.to contain_knot__records__srv("SRV xmpps-client #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_srv(params[:xmpps_client].map { |item| item.merge({ target: params[:dest_target] }) })
        .with_service(params[:xmpps_client_service])
        .with_ttl(params[:ttl])
    }

    it {
      is_expected.to contain_knot__records__srv("SRV xmpp-server #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_srv(params[:xmpp_server].map { |item| item.merge({ target: params[:dest_target] }) })
        .with_service(params[:xmpp_server_service])
        .with_ttl(params[:ttl])
    }

    it {
      is_expected.to contain_knot__records__srv("SRV xmpps-server #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_srv(params[:xmpps_server].map { |item| item.merge({ target: params[:dest_target] }) })
        .with_service(params[:xmpps_server_service])
        .with_ttl(params[:ttl])
    }

    it {
      is_expected.to contain_knot__records__tlsa("XMPPS TLSA #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_tlsa(params[:tlsa])
        .with_ttl(params[:ttl])
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let(:title) { 'xmpp.example.org' }
        let :params do
          default_params.merge(dest_server: 'xmpp.example.org',
                               rname: 'xmpp',
                               target_zone: 'example.org')
        end

        it_behaves_like 'knot::records::xmpp shared examples'
      end
    end
  end
end
