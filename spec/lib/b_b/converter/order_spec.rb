require "spec_helper"

describe BB::Converter::Order do
  describe "#convert" do
    let(:instance) { build :converter_order, type }
    let(:result)   { format(described_class::TEMPLATE, instance.column, instance.sort_key) }

    subject { instance.convert }

    %i(asc desc undefined).each do |type|
      context "when type is #{type}" do
        let(:type) { type }

        it { is_expected.to eq result }
      end
    end
  end

  describe "#format_sort_key" do
    let(:instance) { build :converter_order }

    subject { instance.send(:format_sort_key, sort_key) }

    context "when sort_key is ASC" do
      let(:sort_key) { :asc }
      let(:result)   { :ASC }

      it { is_expected.to be result }
    end

    context "when sort_key is DESC" do
      let(:sort_key) { :desc }
      let(:result)   { :DESC }

      it { is_expected.to be result }
    end

    context "when sort_key is undefined" do
      let(:sort_key) { :undefined }
      let(:result)   { :ASC }

      it { is_expected.to be result }
    end
  end

  describe ".convert" do
    let(:column)  { Faker::Lorem.word }
    let(:options) { { sort_key: :asc } }

    subject { described_class.convert(column, options) }

    it "should convert to order" do
      expect_any_instance_of(described_class).to receive(:convert).and_return(true)
      is_expected.to be true
    end
  end
end
