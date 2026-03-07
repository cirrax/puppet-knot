# frozen_string_literal: true

require 'spec_helper'

describe 'knot::reverse4_host' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  it { is_expected.to run.with_params('1.2.3.4', 1).and_return('4') }
  it { is_expected.to run.with_params('1.2.3.4', 2).and_return('4.3') }
  it { is_expected.to run.with_params('1.2.3.4', 3).and_return('4.3.2') }
  it { is_expected.to run.with_params('1.2.3.4', 4).and_return('4.3.2.1') }
end
