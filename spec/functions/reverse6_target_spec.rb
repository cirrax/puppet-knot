# frozen_string_literal: true

require 'spec_helper'

describe 'knot::reverse6_target' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  it { is_expected.to run.with_params('abcd::1234', 1).and_return('3.2.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.d.c.b.a.ip6.arpa') }
  it { is_expected.to run.with_params('abcd::1234', 2).and_return('2.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.d.c.b.a.ip6.arpa') }
  it { is_expected.to run.with_params('abcd::1234', 21).and_return('0.0.0.0.0.0.0.d.c.b.a.ip6.arpa') }
  it { is_expected.to run.with_params('abcd::1234', 32).and_return('ip6.arpa') }
  it { is_expected.to run.with_params('::1', 1).and_return('0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa') }
end
