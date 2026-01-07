# frozen_string_literal: true

require 'spec_helper'

describe 'knot' do
  let :default_params do
    {
      service_name: 'knot',
      service_ensure: 'running',
      service_enable: true,
      packages: ['knot', 'knot-keymgr'],
      config_file: '/etc/knot/knot.conf',
      config_dir: '/etc/knot/conf.d',
      owner: 'root',
      group: 'knot',
      mode: '0640',
      domains: {},
    }
  end

  shared_examples 'knot shared examples' do
    it { is_expected.to compile.with_all_deps }

    it {
      params[:packages].each do |p|
        is_expected.to contain_package(p)
          .with_ensure('installed')
          .with_before(["File[#{params[:config_dir]}]"] + ["File[#{params[:config_file]}]"])
      end
    }

    it {
      is_expected.to contain_service('knot')
        .with_name(params[:service_name])
        .with_ensure(params[:service_ensure])
        .with_enable(params[:service_enable])
    }

    it {
      is_expected.to contain_file(params[:config_dir])
        .with_ensure('directory')
        .with_owner(params[:owner])
        .with_group(params[:group])
        .with_mode(params[:mode])
    }

    it {
      is_expected.to contain_file(params[:config_file])
        .with_owner(params[:owner])
        .with_group(params[:group])
        .with_mode(params[:mode])
        .with_notify('Service[knot]')
    }

    it {
      params[:domains].each do |dom, _vals|
        is_expected.to contain_knot__domain(dom)
      end
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let :params do
          default_params
        end

        it_behaves_like 'knot shared examples'
      end

      context 'with non defaults' do
        let :params do
          default_params.merge(
            domains: { 'example.net' => {} }
          )
        end

        it_behaves_like 'knot shared examples'
      end
    end
  end
end
