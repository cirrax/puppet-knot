# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::sshfp::export' do
  let :default_params do
    {}
  end

  shared_examples 'knot::records::sshfp::export shared examples' do
    it { is_expected.to compile.with_all_deps }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let :params do
          default_params
        end

        it_behaves_like 'knot::records::sshfp::export shared examples'
      end
    end
  end
end
