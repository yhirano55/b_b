require "spec_helper"

RSpec.describe BB::Evaluator::Table do
  describe '#eval_type' do
    subject { instance.eval_type }

    BB::Evaluator::Table::EVALUATE_TYPES.each do |type|
      context "when type is #{type}" do
        let(:instance) { build :evaluator_table, type }

        it { is_expected.to be type }
      end
    end
  end

  BB::Evaluator::Table::EVALUATE_TYPES.each do |type|
    method_name = "#{type}?"

    describe "##{method_name}" do
      subject { instance.send(method_name) }

      context "when type is #{type}" do
        let(:instance) { build :evaluator_table, type }

        it { is_expected.to be true }
      end

      wrong_types = BB::Evaluator::Table::EVALUATE_TYPES - [type]

      wrong_types.each do |wrong_type|
        context "when type is #{wrong_type}" do
          let(:instance) { build :evaluator_table, wrong_type }

          it { is_expected.to be false }
        end
      end
    end
  end

  describe ".eval_type" do
    let(:value)   { Faker::Lorem.word }
    let(:options) { Hash.new }

    subject { described_class.eval_type(value, options) }

    it "should evaluate type of table" do
      expect_any_instance_of(described_class).to receive(:eval_type).and_return(true)
      is_expected.to be true
    end
  end
end
