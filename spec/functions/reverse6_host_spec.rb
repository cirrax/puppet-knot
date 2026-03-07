# frozen_string_literal: true

require 'spec_helper'

describe 'knot::reverse6_host' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  it { is_expected.to run.with_params('::1', 1).and_return('1') }
  it { is_expected.to run.with_params('::bb42', 2).and_return('2.4') }
  it { is_expected.to run.with_params('42::1', 21).and_return('1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0') }
  it { is_expected.to run.with_params('ff42::cafe', 32).and_return('e.f.a.c.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.2.4.f.f') }
end
