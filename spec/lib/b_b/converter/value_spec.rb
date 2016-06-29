require "spec_helper"

describe BB::Converter::Value do
  describe "#convert" do
    subject { instance.convert }

    BB::Evaluator::Value::EVALUATE_TYPES.each do |type|
      context "when type is #{type}" do
        let(:instance) { build :converter_value, type }

        it "should call method for #{type}" do
          expect(instance).to receive(:"to_#{type}").and_return(true).once
          is_expected.to be true
        end
      end

      context "when set options[:type]" do
        let(:instance) { build :converter_value, options: { type: type } }

        it "should call method for #{type}" do
          expect(instance).to receive(:"to_#{type}").and_return(true).once
          is_expected.to be true
        end
      end
    end
  end

  describe "#format_type" do
    subject { instance.send(:format_type) }

    BB::Evaluator::Value::EVALUATE_TYPES.each do |type|
      context "when type is #{type}" do
        let(:instance) { build :converter_value, type }

        it { is_expected.to eq type }
      end
    end

    context "when set type" do
      let(:instance) { build :converter_value, options: { type: type } }
      let(:type) { :timestamp }

      it { is_expected.to eq type }
    end
  end

  describe "#to_array" do
    let(:instance) { build :converter_value, :array }
    let(:member_values) do
      instance.value.map do |value|
        described_class.convert(value, eval_types: %i(boolean date null numeric string time))
      end
    end
    let(:result) do
      format(described_class::TEMPLATE[:array], member_values.join(", "))
    end

    subject { instance.send(:to_array) }

    it { is_expected.to eq result }
  end

  %i(boolean numeric).each do |type|
    describe "#to_#{type}" do
      let(:instance) { build :converter_value, type }
      let(:result) { instance.value.to_s }

      subject { instance.send("to_#{type}") }

      it { is_expected.to eq result }
    end
  end

  %i(date time timestamp).each do |type|
    describe "#to_#{type}" do
      let(:instance) { build :converter_value, type }
      let(:result) { instance.value.strftime(described_class::TEMPLATE[type]) }

      subject { instance.send("to_#{type}") }

      it { is_expected.to eq result }
    end
  end

  describe "#to_null" do
    let(:instance) { build :converter_value, :null }
    let(:result) { described_class::TEMPLATE[:null] }

    subject { instance.send(:to_null) }

    it { is_expected.to eq result }
  end

  describe "#to_range" do
    let(:instance) { build :converter_value, :range }
    let(:range_values) do
      instance.send(:extract_range_values, instance.value).map do |value|
        described_class.convert(value, eval_types: %i(boolean date null numeric string time))
      end
    end
    let(:result) do
      format(described_class::TEMPLATE[:range], range_values[0], range_values[1])
    end

    subject { instance.send(:to_range) }

    it { is_expected.to eq result }
  end

  describe "#to_regexp" do
    let(:instance) { build :converter_value, :regexp }
    let(:result) { format(described_class::TEMPLATE[:regexp], instance.value.inspect[1..-2]) }

    subject { instance.send(:to_regexp) }

    it { is_expected.to eq result }
  end

  describe "#to_string" do
    let(:instance) { build :converter_value, :string }
    let(:result) { format(described_class::TEMPLATE[:string], instance.value) }

    subject { instance.send(:to_string) }

    it { is_expected.to eq result }
  end

  describe "#to_subquery" do
    let(:instance) { build :converter_value, :subquery }
    let(:result) { format(described_class::TEMPLATE[:subquery], instance.value.to_sql) }

    subject { instance.send(:to_subquery) }

    it { is_expected.to eq result }
  end

  describe "#convert_member_value" do
    let(:instance) { build :converter_value }

    subject { instance.send(:convert_member_value, value) }

    context "with eval_types" do
      eval_types = %i(boolean date null numeric string time)

      eval_types.each do |type|
        context "when type of value is #{type}" do
          let(:member) { build(:converter_value, type) }
          let(:value)  { member.value }

          it "should return convert value" do
            is_expected.to eq member.convert
          end
        end
      end
    end

    context "without eval_types" do
      let(:value) { Faker::Lorem.words }

      it "should raise error" do
        expect { subject }.to raise_error(BB::UnevaluableTypeError, "unevaluable type of value: #{value} (#{value.class})")
      end
    end
  end

  describe "#extract_range_values" do
    let(:instance) { build :converter_value }

    subject { instance.send(:extract_range_values, value) }

    context "when value is exclude end" do
      context "when value is not kind of Time" do
        let(:value) { DateTime.new(1999, 1, 1)...DateTime.new(2000, 1, 1) }
        let(:result) { [value.begin, value.last(1)[0]] }

        it { is_expected.to eq result }
      end

      context "when value is kind of Time" do
        let(:value) { Time.new(1999, 1, 1)...Time.new(2000, 1, 1) }
        let(:result) { [value.begin, (value.last - 1)] }

        it { is_expected.to eq result }
      end
    end

    context "when value is include end" do
      let(:value) { 1..10 }
      let(:result) { [value.begin, value.end] }

      it { is_expected.to eq result }
    end
  end

  describe ".convert" do
    let(:value) { Faker::Lorem.word }

    subject { described_class.convert(value) }

    it "should convert to value" do
      expect_any_instance_of(described_class).to receive(:convert).and_return(true)
      is_expected.to be true
    end
  end
end
