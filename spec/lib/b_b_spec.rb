require "spec_helper"

describe BB do
  describe ".method_missing" do
    BB::API.values.flatten.each do |method_name|
      context "Relation##{method_name}" do
        subject { described_class.public_send(method_name, *args) }

        context "when args are empty" do
          let(:args) { [] }

          it { expect { subject }.to raise_error(BB::ArgumentError, "wrong number of arguments ##{method_name} (at least 1)") }
        end

        context "when args are not empty" do
          let(:args) { %w(123) }

          it { is_expected.to be_an_instance_of(BB::Relation) }
        end
      end
    end

    %i(and or not).each do |method_name|
      context "Relation##{method_name}" do
        subject { described_class.public_send(method_name) }

        it { is_expected.to be_an_instance_of(BB::Relation) }
      end
    end

    context "undefined method" do
      subject { described_class.undefined_method }

      it { expect { subject }.to raise_error(NoMethodError) }
    end
  end

  describe ".respond_to?" do
    BB::API.values.flatten.each do |method_name|
      context "Relation##{method_name}" do
        subject { described_class.respond_to?(method_name) }

        it { is_expected.to be true }
      end
    end

    %i(and or not).each do |method_name|
      context "Relation##{method_name}" do
        subject { described_class.respond_to?(method_name) }

        it { is_expected.to be true }
      end
    end

    context "undefined method" do
      subject { described_class.respond_to?(:undefined_method) }

      it { is_expected.to be false }
    end
  end
end
