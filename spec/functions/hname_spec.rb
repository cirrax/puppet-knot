# frozen_string_literal: true

require 'spec_helper'

describe 'knot::hname' do
  context 'returns hostname of a fqdn' do
    it { is_expected.to run.with_params('a.b.c.d').and_return('a') }
    it { is_expected.to run.with_params('d').and_return('.') }
    it { is_expected.to run.with_params('c.d').and_return('.') }
    it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
  end
end
