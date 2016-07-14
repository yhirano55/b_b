require "spec_helper"

RSpec.describe BB::Evaluator::Formula do
  describe "#eval_type" do
    subject { instance.eval_type }

    BB::Evaluator::Formula::EVALUATE_TYPES.each do |type|
      context "when type is #{type}" do
        context "without option" do
          let(:instance) { build :evaluator_formula, type }

          it { is_expected.to be type }
        end

        context "with negation option" do
          let(:negative_type) { :"not_#{type}" }
          let(:instance) { build :evaluator_formula, type }

          before { instance.instance_variable_set(:@negation, true) }

          it { is_expected.to be negative_type }
        end

        if %i(contains equals gt gteq lt lteq).include?(type)
          context "with operator start with 'not'" do
            let(:negative_type) { :"not_#{type}" }
            let(:instance) { build :evaluator_formula, negative_type }

            it { is_expected.to be negative_type }
          end
        end
      end
    end
  end

  describe "#negative?" do
    subject { instance.send(:negative?) }

    context "when negation is true" do
      let(:instance) { described_class.new(nil, negation: true) }

      it { is_expected.to be true }
    end

    context "when negation is not true" do
      context "when operator is start with 'not'" do
        let(:instance) { described_class.new(nil, operator: :not_contains, negation: false) }

        it { is_expected.to be true }
      end

      context "when operator is not start with 'not'" do
        let(:instance) { described_class.new(nil, operator: :contains, negation: false) }

        it { is_expected.to be false }
      end
    end
  end

  describe "#double_negative?" do
    subject { instance.send(:double_negative?) }

    context "when negation is true and operator is start with 'not'" do
      let(:instance) { described_class.new(nil, operator: :not_contains, negation: true) }

      it { is_expected.to be true }
    end

    context "when negation is false and operator is start with 'not'" do
      let(:instance) { described_class.new(nil, operator: :not_contains, negation: false) }

      it { is_expected.to be false }
    end

    context "when negation is true and operator is not start with 'not'" do
      let(:instance) { described_class.new(nil, operator: :contains, negation: true) }

      it { is_expected.to be false }
    end
  end

  BB::Evaluator::Formula::EVALUATE_TYPES.each do |type|
    method_name = "#{type}?"

    describe "##{method_name}" do
      subject { instance.send(method_name) }

      context "when type is #{type}" do
        let(:instance) { build :evaluator_formula, type }

        it { is_expected.to be true }
      end

      wrong_types = BB::Evaluator::Formula::EVALUATE_TYPES - [type]

      wrong_types.each do |wrong_type|
        context "when type is #{wrong_type}" do
          let(:instance) { build :evaluator_formula, wrong_type }

          it { is_expected.to be false }
        end
      end
    end
  end

  describe ".eval_type" do
    let(:value)   { Faker::Lorem.word }
    let(:options) { Hash.new }

    subject { described_class.eval_type(value, options) }

    it "should evaluate type of formula" do
      expect_any_instance_of(described_class).to receive(:eval_type).and_return(true)
      is_expected.to be true
    end
  end
end
