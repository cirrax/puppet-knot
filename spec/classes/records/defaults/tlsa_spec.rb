# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::defaults::tlsa' do
  let :default_params do
    {}
  end

  shared_examples 'knot::records::defaults::tlsa shared examples' do
    it { is_expected.to compile.with_all_deps }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let :params do
          default_params
        end

        it_behaves_like 'knot::records::defaults::tlsa shared examples'
      end
    end
  end
end
