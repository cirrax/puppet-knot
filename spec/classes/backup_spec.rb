# frozen_string_literal: true

require 'spec_helper'

describe 'knot::backup' do
  let :default_params do
    {
      dir: '/var/lib/knot-backup',
      owner: 'knot',
      group: 'knot',
      mode: '0700',
      timer: ['OnCalendar=*-*-* 01:00:00', 'Persistent=true'],
      key_stati_file: '/var/lib/knot-backup/current-key-list.txt'
    }
  end

  shared_examples 'knot::backup shared examples' do
    it { is_expected.to compile.with_all_deps }

    it {
      [params[:dir], "#{params[:dir]}/current", "#{params[:dir]}/previous"].each do |d|
        is_expected.to contain_file(d)
          .with_ensure('directory')
          .with_owner(params[:owner])
          .with_group(params[:group])
          .with_mode(params[:mode])
          .with_before('Systemd::Timer[knot-backup.timer]')
      end
    }

    it {
      if params[:list_keys_script]
        is_expected.to contain_file(params[:list_keys_script])
          .with_ensure('file')
          .with_owner('root')
          .with_group('root')
          .with_mode('0755')
          .with_before('Systemd::Timer[knot-backup.timer]')
      end
    }

    it {
      is_expected.to contain_systemd__timer('knot-backup.timer')
        .with_ensure('present')
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let :params do
          default_params
        end

        it_behaves_like 'knot::backup shared examples'
      end

      context 'with non defaults' do
        let :params do
          default_params.merge(
            dir: '/tmp/bla',
            owner: 'pdns',
            group: 'bind',
            mode: '0000',
            timer: ['OnCalender=\never'],
            list_keys_script: '/usr/local/bin/script'
          )
        end

        it_behaves_like 'knot::backup shared examples'
      end
    end
  end
end
