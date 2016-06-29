require "spec_helper"

describe BB::FactoryDecorator::Joinable do
  let(:factory) { BB::Factory.new.extend(described_class) }

  describe "#format_filters" do
    let(:expressions) { %w(table1 table2 table3) }
    let(:result) do
      expressions.map do |expression|
        BB::Converter::Table.convert(expression, factory.options)
      end
    end

    subject { factory.send(:format_filters, expressions) }

    it "should return formatted values" do
      is_expected.to match_array(result)
    end
  end

  describe "#format_condition" do
    let(:value) { "table" }
    let(:result) do
      BB::Converter::Table.convert(value, factory.options)
    end

    subject { factory.send(:format_condition, value) }

    it { is_expected.to eq result }
  end
end
