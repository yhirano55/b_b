require "spec_helper"

RSpec.describe BB::Evaluator::Value do
  describe "#eval_type" do
    subject { instance.eval_type }

    context "with EVALUATE_TYPES" do
      BB::Evaluator::Value::EVALUATE_TYPES.each do |type|
        context "when value is #{type}" do
          let(:instance) { build :evaluator_value, type }

          it { is_expected.to be type.to_sym }
        end
      end
    end

    context "with :eval_types" do
      let(:eval_types) { %i(array boolean string) }
      let(:expected_type) { eval_types.sample }
      let(:instance) do
        build :evaluator_value, expected_type, options: { eval_types: eval_types }
      end

      it { is_expected.to be expected_type }
    end

    context "when not evaluate value" do
      let(:instance) { build :evaluator_value, value: value }
      let(:value) { Object.new }

      it "should raise error" do
        expect { subject }.to raise_error(BB::UnevaluableTypeError, "unevaluable type of value: #{value} (#{value.class})")
      end
    end
  end

  BB::Evaluator::Value::EVALUATE_TYPES.each do |type|
    method_name = "#{type}?"

    describe "##{method_name}" do
      subject { instance.send(method_name) }

      context "when value is #{type}" do
        let(:instance) { build :evaluator_value, type }

        it { is_expected.to be true }
      end

      wrong_types = BB::Evaluator::Value::EVALUATE_TYPES - [type]

      wrong_types.each do |wrong_type|
        context "when value is #{wrong_type}" do
          let(:instance) { build :evaluator_value, wrong_type }

          it { is_expected.to be false }
        end
      end
    end
  end

  describe ".eval_type" do
    let(:value)   { Faker::Lorem.word }
    let(:options) { Hash.new }

    subject { described_class.eval_type(value, options) }

    it "should evaluate type of value" do
      expect_any_instance_of(described_class).to receive(:eval_type).and_return(true)
      is_expected.to be true
    end
  end
end
