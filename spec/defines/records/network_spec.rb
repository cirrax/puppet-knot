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
    end
  end
end
