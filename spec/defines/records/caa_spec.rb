# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::caa' do
  let :default_params do
    { ttl: 3600,
      caa: [], }
  end

  shared_examples 'knot::records::caa shared examples' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('knot::records::defaults::caa') }

    it {
      i = 0
      params[:caa].each do |caa|
        is_expected.to contain_knot_record("caa: #{title} (#{i})")
          .with_target_zone(params[:target_zone])
          .with_rname(params[:rname])
          .with_rttl(params[:ttl])
          .with_rcontent("#{caa[:flags]} #{caa[:tag]} \"#{caa[:value]}\" ")  # space at the end is needed !
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
          default_params
        end

        it_behaves_like 'knot::records::caa shared examples'
      end

      context 'with caa set' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(target_zone: 'example.org', rname: 'test', caa: [{ flags: 0, tag: 'issue', value: 'letsencrypt.org' }])
        end

        it_behaves_like 'knot::records::caa shared examples'
      end
    end
  end
end
