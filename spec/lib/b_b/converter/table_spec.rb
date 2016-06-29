require "spec_helper"

describe BB::Converter::Table do
  describe "#convert" do
    subject { instance.convert }

    BB::Evaluator::Table::EVALUATE_TYPES.each do |type|
      context "when type is #{type}" do
        let(:instance) { build :converter_table, type }

        it "should call converting method for #{type}" do
          expect(instance).to receive(:"to_#{type}").and_return(true).once
          is_expected.to be true
        end
      end
    end
  end

  describe "#to_subquery" do
    let(:instance) { build :converter_table, :subquery }
    let(:result) do
      format(described_class::TEMPLATE[:subquery], instance.value.to_sql)
    end

    subject { instance.send(:to_subquery) }

    it { is_expected.to eq result }
  end

  describe "#to_table_date" do
    let(:instance) { build :converter_table, :table_date }
    let(:result) do
      instance.options[:on].strftime("#{instance.value}%Y%m%d")
    end

    subject { instance.send(:to_table_date) }

    it { is_expected.to eq result }
  end

  describe "#to_table_date_range" do
    let(:instance) { build :converter_table, :table_date_range }
    let(:result) do
      from = BB::Converter::Value.convert(instance.options[:from], type: :timestamp)
      to   = BB::Converter::Value.convert(instance.options[:to],   type: :timestamp)

      format(described_class::TEMPLATE[:table_date_range], instance.value, from, to)
    end

    subject { instance.send(:to_table_date_range) }

    it { is_expected.to eq result }
  end

  describe "#to_plain" do
    let(:instance) { build :converter_table, :plain }
    let(:result) { instance.value.to_s }

    subject { instance.send(:to_plain) }

    it { is_expected.to eq result }
  end

  describe ".convert" do
    let(:value)   { Faker::Lorem.word }
    let(:options) { Hash.new }

    subject { described_class.convert(value, options) }

    it "should convert to table" do
      expect_any_instance_of(described_class).to receive(:convert).and_return(true)
      is_expected.to be true
    end
  end
end
