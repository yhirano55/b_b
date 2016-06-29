require "spec_helper"

describe BB::Factory do
  let(:factory) { described_class.new }

  describe "#build" do
    before do
      factory.filters           = [100]
      factory.type_of_component = :limit
    end

    subject { factory.build }

    it "should build through component" do
      is_expected.to be_kind_of(String)
    end
  end

  describe "#append_formatted_filters" do
    let(:args) { [] }
    let(:message) { "You must implemented #{described_class}#format_filters" }

    subject { factory.append_formatted_filters(args) }

    it { expect { subject }.to raise_error(BB::NotImplementedError, message) }
  end

  describe "#extract_options!" do
    subject { factory.send(:extract_options!, args) }

    context "when size of args are less than 1" do
      let(:args) { [123] }

      it { is_expected.to be_nil }
    end

    context "when size of args are greater than 1 and args are not kind of Hash" do
      let(:args) { [123, 456] }

      it { is_expected.to be_nil }
    end

    context "when size of args are greater than 1 and args are kind of Hash" do
      let(:args) { [123, { key: 456 }] }

      it "should merge options" do
        is_expected.not_to be_nil
        expect(factory.options[:key]).to be 456
      end
    end
  end

  describe "#format_filters" do
    let(:expressions) { [] }
    let(:message) { "You must implemented #{described_class}#format_filters" }

    subject { factory.send(:format_filters, expressions) }

    it { expect { subject }.to raise_error(BB::NotImplementedError, message) }
  end

  describe "#component" do
    subject { factory.send(:component) }

    it { is_expected.to be_an_instance_of(BB::Component) }
  end

  describe "#format_type_of_component" do
    let(:type_of_component) { factory.type_of_component }

    subject { factory.send(:format_type_of_component) }

    it { is_expected.to eq type_of_component }
  end

  describe ".build" do
    let(:name) { :select }

    subject { described_class.build(name) }

    it { is_expected.to be_an_instance_of(described_class) }
  end

  describe ".format_decorator_name" do
    subject { described_class.send(:format_decorator_name, name) }

    context "when name is :group or :group_each or :select" do
      it "returns :Selectable" do
        %i(group group_each select).each do |name|
          actual = described_class.send(:format_decorator_name, name)
          expect(actual).to be :Selectable
        end
      end
    end

    context "when name is :having or :omit_record_if or :where" do
      it "returns :Extractable" do
        %i(having omit_record_if where).each do |name|
          actual = described_class.send(:format_decorator_name, name)
          expect(actual).to be :Extractable
        end
      end
    end

    context "when name is #{BB::API[:joins].join(' or ')}" do
      it "returns :Joinable" do
        BB::API[:joins].each do |name|
          actual = described_class.send(:format_decorator_name, name)
          expect(actual).to be :Joinable
        end
      end
    end

    context "when name is others" do
      it "returns camelized name of itself" do
        %i(from order limit).each do |name|
          actual = described_class.send(:format_decorator_name, name)
          expect = name.to_s.scan(/[^-_]+/).map(&:capitalize).join.to_sym
          expect(actual).to be expect
        end
      end
    end
  end
end
