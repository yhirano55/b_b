require "spec_helper"

describe BB::FactoryDecorator::From do
  let(:factory) { BB::Factory.new.extend(described_class) }

  describe "#format_filters" do
    let(:expressions) { [:table1, :table2, :table3, nil] }
    let(:result) { %w(table1 table2 table3) }

    subject { factory.send(:format_filters, expressions) }

    it "should return formatted values" do
      is_expected.to eq result
    end
  end

  describe "#format_condition" do
    let(:value) { :table }
    let(:result) { BB::Converter::Table.convert(value, factory.options) }

    subject { factory.send(:format_condition, value) }

    it { is_expected.to eq result }
  end

  describe "#format_type_of_component" do
    subject { factory.send(:format_type_of_component) }

    context "when options[:as] is present" do
      context "when size of filters are greater than 1" do
        before do
          factory.filters = %w(table1 table2 table3)
          factory.options[:as] = :table
        end

        it { is_expected.to be :from_union_all_with_alias }
      end

      context "when size of filters equals 1" do
        before do
          factory.filters = %w(table)
          factory.options[:as] = :table
        end

        it { is_expected.to be :from_with_alias }
      end
    end

    context "when options[:as] is blank" do
      before do
        factory.filters = %w(table1 table2 table3)
      end

      it { is_expected.to be :from }
    end
  end
end
