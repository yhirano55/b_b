require "spec_helper"

describe BB::FactoryDecorator::Limit do
  let(:factory) { BB::Factory.new.extend(described_class) }

  describe "#format_filters" do
    let(:expressions) { %w(100 200 300 abc def) }
    let(:result) { expressions.map(&:to_i).reject(&:zero?) }

    subject { factory.send(:format_filters, expressions) }

    it "should return format values" do
      is_expected.to match_array(result)
    end
  end

  describe "#match?" do
    subject { factory.send(:match?, value) }

    context "when value can respond to :to_i" do
      context "when value to integer is nonzero" do
        let(:value) { "300" }

        it { is_expected.to be true }
      end

      context "when value to integer is zero" do
        let(:value) { "abc" }

        it { is_expected.to be false }
      end
    end

    context "when value cannot respond to :to_i" do
      let(:value) { Object.new }

      it { is_expected.to be false }
    end
  end

  describe "#format_type_of_component" do
    subject { factory.send(:format_type_of_component) }

    context "when options[:offset] is present" do
      before do
        factory.options[:offset] = 10
      end

      it { is_expected.to be :limit_with_offset }
    end

    context "when options[:offset] is blank" do
      it { is_expected.to be :limit }
    end
  end
end
