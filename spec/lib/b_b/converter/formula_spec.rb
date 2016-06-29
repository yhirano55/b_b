require "spec_helper"

describe BB::Converter::Formula do
  describe "#convert" do
    subject { instance.convert }

    BB::Converter::Formula::TEMPLATE.keys.each do |type|
      context "when type is #{type}" do
        let(:instance) { build :converter_formula, type }
        let(:result) do
          format(described_class::TEMPLATE[type], instance.column, instance.value.convert)
        end

        it { is_expected.to eq result }
      end
    end
  end

  describe "#format_column" do
    let(:instance) { build :converter_formula }

    subject { instance.send(:format_column, column) }

    context "when column is SEARCHABLE_COLUMN_FORMAT" do
      let(:expected_column) { Faker::Lorem.word }
      let(:column) { [expected_column, expected_operator].join("_") }

      context "when operator not includes 'not'" do
        let(:expected_operator) { :equals }

        it "should return expected_column" do
          is_expected.to eq expected_column
          expect(instance.operator).to eq expected_operator
        end
      end

      context "when operator not includes 'not'" do
        let(:expected_operator) { :not_equals }

        it "should return expected_column" do
          is_expected.to eq expected_column
          expect(instance.operator).to eq expected_operator
        end
      end
    end

    context "when column is not SEARCHABLE_COLUMN_FORMAT" do
      let(:column) { [Faker::Lorem.word, :not_defined_operator].join("_") }

      it "should return column as original value" do
        is_expected.to eq column
        expect(instance.operator).to be_nil
      end
    end
  end

  describe "#format_operator" do
    let(:instance) { build :converter_formula }

    subject { instance.send(:format_operator, operator) }

    context "when operator matches OPERATORS_DICTIONARY" do
      let(:operator) { described_class::OPERATORS_DICTIONARY.values.sample }

      it { is_expected.to be operator }
    end

    context "when operator unmatches OPERATORS_DICTIONARY" do
      let(:operator) { :not_defined_operator }

      it { is_expected.to be_nil }
    end
  end

  describe "#format_value" do
    let(:instance) { build :converter_formula }

    subject { instance.send(:format_value, value) }

    context "when value is a kind of Converter::Value" do
      let(:value) { build :converter_value }

      it { is_expected.to eq value }
    end

    context "when value is raw value" do
      let(:value) { Faker::Lorem.word }

      it { is_expected.to be_kind_of(BB::Converter::Value) }
    end
  end

  describe ".convert" do
    let(:column) { Faker::Lorem.word }
    let(:value)  { Faker::Lorem.word }

    subject { described_class.convert(column, value) }

    it "should convert to formula" do
      expect_any_instance_of(described_class).to receive(:convert).and_return(true)
      is_expected.to be true
    end
  end
end
