# frozen_string_literal: true

require 'spec_helper'

describe 'knot::add_conf' do
  let :default_params do
    { ensure: 'present',
      filename: 'example.net.conf',
      config_dir: '/etc/knot/conf.d' }
  end

  shared_examples 'knot::add_conf shared examples' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('knot') }

    it {
      if params[:ensure] == 'present'
        is_expected.to contain_file("#{params[:config_dir]}/#{params[:filename]}")
          .with_ensure('file')
          .with_owner('root')
          .with_group('knot')
          .with_mode('0640')
          .with_notify('Service[knot]')
      else
        is_expected.to contain_file("#{params[:config_dir]}/#{params[:filename]}")
          .with_ensure(params[:ensure])
          .with_owner('root')
          .with_group('knot')
          .with_mode('0640')
          .with_notify('Service[knot]')
      end
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let(:title) { 'example.net' }
        let :params do
          default_params
        end

        it_behaves_like 'knot::add_conf shared examples'
      end

      context 'with parameters' do
        let(:title) { 'test' }
        let :params do
          default_params.merge({
                                 ensure: 'absent',
                                 filename: 'example.org.conf',
                               })
        end

        it_behaves_like 'knot::add_conf shared examples'
      end
    end
  end
end
