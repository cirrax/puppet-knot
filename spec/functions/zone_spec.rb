# frozen_string_literal: true

require 'spec_helper'

describe 'knot::zone' do
  context 'returns zone of a fqdn' do
    it { is_expected.to run.with_params('a.b.c.d').and_return('b.c.d') }
    it { is_expected.to run.with_params('d').and_return('d') }
    it { is_expected.to run.with_params('c.d').and_return('c.d') }
    it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
  end
end
