require "spec_helper"

describe BB::FactoryDecorator::Order do
  let(:factory) { BB::Factory.new.extend(described_class) }

  describe "#format_filters" do
    let(:expressions) do
      [{ column1: :asc, column2: :desc }]
    end

    let(:result) do
      ["column1 ASC, column2 DESC"]
    end

    subject { factory.send(:format_filters, expressions) }

    it "should return formatted values" do
      is_expected.to eq result
    end
  end

  describe "#format_condition" do
    subject { factory.send(:format_condition, value) }

    context "when value is kind of Hash" do
      let(:value) { { column1: :asc, column2: :desc } }
      let(:result) { "column1 ASC, column2 DESC" }

      it { is_expected.to eq result }
    end

    context "when value is not kind of String" do
      context "when value is not empty" do
        let(:value) { "column1 ASC" }

        it { is_expected.to eq value }
      end

      context "when value is empty" do
        let(:value) { "" }

        it { is_expected.to be_nil }
      end
    end

    context "when value is kind of Symbol" do
      let(:value) { :symbol }
      let(:result) { value.to_s }

      it { is_expected.to eq result }
    end

    context "when value isnt kind of Hash/String/Symbol" do
      let(:value) { Object.new }

      it { is_expected.to be_nil }
    end
  end
end
