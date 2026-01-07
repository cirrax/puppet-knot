# frozen_string_literal: true

require 'spec_helper'

describe 'knot::domain' do
  let :default_params do
    { ensure: 'present',
      manage_zone: false,
      zone_records: [],
      zone_nameservers_ttl: 3600,
      zone_nameservers: [],
      zone_subzones: {} }
  end

  shared_examples 'knot::domain shared examples' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_knot__add_conf(params[:domain]) }

    it {
      if params[:manage_zone]
        is_expected.to contain_knot_zone(params[:domain])
          .with_zone_ensure(params[:ensure])
          .with_manage_records(params[:zone_manage_records])
        if params[:ensure] == 'present'
          i = 0
          params[:zone_records].each do |r|
            is_expected.to contain_knot_record("record #{r[:rname]}.#{params[:domain]} (#{i})")
              .with_target_zone(params[:domain])
              .with_rname(r[:rname])
              .with_rcontent(r[:rcontent])
            i += 1
          end
          params[:zone_nameservers].each do |r|
            is_expected.to contain_knot_record("Nameserver: #{r} for #{params[:domain]}")
              .with_target_zone(params[:domain])
              .with_rname('.')
              .with_rtype('NS')
              .with_rttl(params[:zone_nameservers_ttl])
              .with_rcontent(r)
          end
          params[:zone_subzones].each do |z, v|
            v['nameservers']&.each do |r|
              is_expected.to contain_knot_record("Subzone Nameserver: #{r} for #{z}")
                .with_target_zone(params[:domain])
                .with_rname(z)
                .with_rtype('NS')
                .with_rttl(params[:zone_nameservers_ttl])
                .with_rcontent(r)
            end

            v['trust_ds']&.each do |r|
              is_expected.to contain_knot_record("Subzone DS for #{z} (#{r})")
                .with_target_zone(params[:domain])
                .with_rname(z)
                .with_rtype('DS')
                .with_rttl(params[:zone_nameservers_ttl])
                .with_rcontent(r)
            end
          end

        else
          params[:zone_records].each do |r|
            is_expected.not_to contain_knot_record("record #{r[:rname]}.#{params[:domain]} (#{i})")
          end
          params[:zone_nameservers].each do |r|
            is_expected.not_to contain_knot_record("Nameserver: #{r} for #{params[:domain]}")
          end
          params[:zone_subzones].each do |z, v|
            v['nameservers']&.each do |r|
              is_expected.not_to contain_knot_record("Subzone Nameserver: #{r} for #{z}")
            end
            v['trust_ds']&.each do |r|
              is_expected.not_to contain_knot_record("Subzone DS for #{z} (#{r})")
            end
          end
        end

      else
        is_expected.not_to contain_knot_zone(params[:domain])
      end
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let(:title) { 'testdomain' }
        let :params do
          default_params.merge({ domain: 'example.org' })
        end

        it_behaves_like 'knot::domain shared examples'
      end

      context 'with manage_zone true' do
        let(:title) { 'testdomain' }
        let :params do
          default_params.merge({
                                 domain: 'example.net',
                                 manage_zone: true,
                                 zone_records: [{ rname: 'test', rcontent: '1.1.1.1' }, { rname: 'test', rtype: 'AAAA', rcontent: '::1' }],
                                 zone_nameservers: ['ns1.example.org.', 'ns2.example.org.'],
                                 zone_subzones: { 'sub' => { 'nameservers' => ['ns1.example.org'], 'trust_ds' => ['1 1 1 ttt'] } }
                               })
        end

        it_behaves_like 'knot::domain shared examples'
      end

      context 'with manage_zone true, but ensure absent' do
        let(:title) { 'testdomain' }
        let :params do
          default_params.merge({ ensure: 'absent',
                                 domain: 'example.net',
                                 manage_zone: true,
                                 zone_records: [{ rname: 'test', rcontent: '1.1.1.1' }, { rname: 'test', rtype: 'AAAA', rcontent: '::1' }],
                                 zone_nameservers: ['ns1.example.org.', 'ns2.example.org.'],
                                 zone_subzones: { 'sub' => { 'nameservers' => ['ns1.example.org'], 'trust_ds' => ['1 1 1 ttt'] } } })
        end

        it_behaves_like 'knot::domain shared examples'
      end
    end
  end
end
