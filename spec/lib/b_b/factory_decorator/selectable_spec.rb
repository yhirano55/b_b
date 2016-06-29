require "spec_helper"

describe BB::FactoryDecorator::Selectable do
  let(:factory) { BB::Factory.new.extend(described_class) }

  describe "#format_filters" do
    let(:expressions) { %w(column1 column2 column3) }

    subject { factory.send(:format_filters, expressions) }

    it "should return formatted values" do
      is_expected.to match_array(expressions)
    end
  end

  describe "#match?" do
    subject { factory.send(:match?, value) }

    context "when value is kind of String" do
      context "when value is not empty" do
        let(:value) { "string" }

        it { is_expected.to be true }
      end

      context "when value is not empty" do
        let(:value) { "" }

        it { is_expected.to be false }
      end
    end

    context "when value is kind of Symbol" do
      let(:value) { :symbol }

      it { is_expected.to be true }
    end

    context "when value isnt kind of String/Symbol" do
      let(:value) { Object.new }

      it { is_expected.to be false }
    end
  end
end
