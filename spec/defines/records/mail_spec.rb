# frozen_string_literal: true

require 'spec_helper'

describe 'knot::records::mail' do
  let :default_params do
    { mailserver: [],
      ttl: 3600,
      caa: [],
      submission: [],
      autodiscover: [],
      imaps: [],
      pop3s: [],
      dkim_keys: {},
      rname: '.',
      spf_rtypes: %w[SPF TXT], }
  end

  shared_examples 'knot::records::mail shared examples' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('knot::records::defaults::mail') }

    it {
      i = 0
      params[:mailserver].each do |v|
        is_expected.to contain_knot_record("mail MX: #{title} (#{i})")
          .with_target_zone(params[:target_zone])
          .with_rname(params[:rname])
          .with_rttl(params[:ttl])
          .with_rcontent("#{v[:prio]} #{v[:target]}")
        i += 1
      end
    }

    it {
      if params[:spf]
        params[:spf_rtypes].each do |sr|
          is_expected.to contain_knot_record("spf (#{sr}): #{title}")
            .with_target_zone(params[:target_zone])
            .with_rname(params[:rname])
            .with_rttl(params[:ttl])
            .with_rtype(sr)
            .with_rcontent("\"v=#{params[:spf]['version']} #{params[:spf]['mechanism'].join(' ')} #{params[:spf]['modifier'].join(' ')}\"")
        end
      end
    }

    it {
      if params[:autoconfig]
        is_expected.to contain_knot_record("autoconfig: #{title}")
          .with_target_zone(params[:target_zone])
          .with_rname('autoconfig')
          .with_rttl(params[:ttl])
          .with_rtype('CNAME')
          .with_rcontent(params[:autoconfig])
      end
    }

    it {
      is_expected.to contain_knot__records__caa("mail CAA #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_caa(params[:caa])
    }

    it {
      is_expected.to contain_knot__records__srv("autodiscover #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_srv(params[:autodiscover])
        .with_service([{ 'port' => 'autodiscover', 'proto' => 'tcp' }])
    }

    it {
      is_expected.to contain_knot__records__srv("submission #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_srv(params[:submission])
        .with_service([{ 'port' => 'submission', 'proto' => 'tcp' }])
    }

    it {
      is_expected.to contain_knot__records__srv("imaps #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_srv(params[:imaps])
        .with_service([{ 'port' => 'imaps', 'proto' => 'tcp' }])
    }

    it {
      is_expected.to contain_knot__records__srv("pop3s #{title}")
        .with_target_zone(params[:target_zone])
        .with_rname(params[:rname])
        .with_srv(params[:pop3s])
        .with_service([{ 'port' => 'pop3s', 'proto' => 'tcp' }])
    }

    it {
      params[:dkim_keys].each do |k, v|
        is_expected.to contain_knot_record("dkim key #{k} for #{title}")
          .with_target_zone(params[:target_zone])
          .with_rname("#{k}._domainkey")
          .with_rttl(params[:ttl])
          .with_rtype('TXT')
          .with_rcontent("\"#{v.join('; ')}\"")
      end
    }

    it {
      if params[:dkim_policy]
        is_expected.to contain_knot_record("dkim policy: #{title}")
          .with_target_zone(params[:target_zone])
          .with_rname('_domainkey')
          .with_rttl(params[:ttl])
          .with_rtype('TXT')
          .with_rcontent("\"#{params[:dkim_policy]}\"")
      end
    }

    it {
      if params[:adsp_policy]
        is_expected.to contain_knot_record("adsp policy: #{title}")
          .with_target_zone(params[:target_zone])
          .with_rname('_adsp._domainkey')
          .with_rttl(params[:ttl])
          .with_rtype('TXT')
          .with_rcontent("\"#{params[:adsp_policy]}\"")
      end
    }

    it {
      if params[:dmarc_policy]
        is_expected.to contain_knot_record("dmarc policy: #{title}")
          .with_target_zone(params[:target_zone])
          .with_rname('_dmarc')
          .with_rttl(params[:ttl])
          .with_rtype('TXT')
          .with_rcontent("\"#{params[:dmarc_policy].join(';')}\"")
      end
    }

    it {
      if params[:dmarc_authorization]
        is_expected.to contain_knot_record("dmarc authorization: #{title}")
          .with_target_zone(params[:dmarc_authorization]['target_zone'])
          .with_rname("#{params[:target_zone]}._report._dmarc")
          .with_rttl(params[:ttl])
          .with_rtype('TXT')
          .with_rcontent("\"#{params[:dmarc_authorization]['record']}\"")
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

        it_behaves_like 'knot::records::mail shared examples'
      end

      context 'with all set for host' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(
            rname: 'test',
            target_zone: 'example.org',
            mailserver: [{ prio: 10, target: 'mail.somewhere.org' }, { prio: 90, target: 'mail.backup.org' }],
            ttl: 4242,
            autodiscover: [{ 'priority' => 10, 'weight' => 0, 'target_port' => 443, 'target' => 'mail.some.org' }],
            autoconfig: 'autoconfig.somewhere.org',
            submission: [{ 'priority' => 10, 'weight' => 0, 'target_port' => 993, 'target' => 'mail.some.org' }],
            pop3s: [{ 'priority' => 10, 'weight' => 0, 'target_port' => 40, 'target' => 'mail.some.org' }],
            caa: [{ 'flags' => 0, 'tag' => 'issue', 'value' => 'some.org' }],
            spf: { 'version' => 'spf1', 'mechanism' => ['ip4:127.0.0.1'], 'modifier' => ['-all'] },
            dkim_keys: { 'mykey' => ['v=DKIM1', 'g=*', 'k=rsa', 'p=***pubkey***'] },
            dkim_policy: 'dkim=all; t=s',
            adsp_policy: 'o=-',
            dmarc_policy: ['p=quarantine', 'adkim=s', 'aspf=s', 'ruf=mailto:dmarc@somewhere.org'],
            dmarc_authorization: { 'target_zone' => 'somewhere.org', 'record' => 'v=DMARC1' }
          )
        end

        it_behaves_like 'knot::records::mail shared examples'
      end

      context 'with all set for domain' do
        let(:title) { 'testdomain.org' }
        let :params do
          default_params.merge(
            rname: '.',
            target_zone: 'example.org',
            mailserver: [{ prio: 10, target: 'mail.somewhere.org' }, { prio: 90, target: 'mail.backup.org' }],
            ttl: 4242,
            autodiscover: [{ 'priority' => 10, 'weight' => 0, 'target_port' => 443, 'target' => 'mail.some.org' }],
            autoconfig: 'autoconfig.somewhere.org',
            submission: [{ 'priority' => 10, 'weight' => 0, 'target_port' => 993, 'target' => 'mail.some.org' }],
            pop3s: [{ 'priority' => 10, 'weight' => 0, 'target_port' => 40, 'target' => 'mail.some.org' }],
            caa: [{ 'flags' => 0, 'tag' => 'issue', 'value' => 'some.org' }],
            spf: { 'version' => 'spf1', 'mechanism' => ['ip4:127.0.0.1'], 'modifier' => ['-all'] },
            dkim_keys: { 'mykey' => ['v=DKIM1', 'g=*', 'k=rsa', 'p=***pubkey***'] },
            dkim_policy: 'dkim=all; t=s',
            adsp_policy: 'o=-',
            dmarc_policy: ['p=quarantine', 'adkim=s', 'aspf=s', 'ruf=mailto:dmarc@somewhere.org'],
            dmarc_authorization: { 'target_zone' => 'somewhere.org', 'record' => 'v=DMARC1' }
          )
        end

        it_behaves_like 'knot::records::mail shared examples'
      end
    end
  end
end
