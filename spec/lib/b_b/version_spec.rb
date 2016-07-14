require "spec_helper"

describe BB do
  subject { described_class::VERSION }
  it { is_expected.not_to be_nil }
end
