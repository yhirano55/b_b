require "spec_helper"

describe BB::Component do
  let(:component) { described_class.new }

  describe "#build" do
    subject { component.build }

    context "when type is present" do
      before do
        component.filters = [100]
        component.type    = :limit
      end

      it { is_expected.to be_kind_of(String) }
    end

    context "when type is blank" do
      it { is_expected.to be_nil }
    end
  end

  (BB::API[:joins] - [:to_cross_join]).each do |type|
    describe "#to_#{type}" do
      let(:filters) { ["table"] }
      let(:options) { { as: :table, on: "t1.id = t2.id" } }
      let(:result) do
        format(described_class::TEMPLATE[type], filters[0], options[:as], options[:rel])
      end

      subject { component.send("to_#{type}") }

      before do
        component.type    = type
        component.filters = filters
        component.options = options
      end

      it { is_expected.to eq result }
    end
  end

  %i(cross_join from_with_alias).each do |type|
    describe "#to_#{type}" do
      let(:filters) { ["table"] }
      let(:options) { { as: :table } }
      let(:result) do
        format(described_class::TEMPLATE[type], filters[0], options[:as])
      end

      subject { component.send("to_#{type}") }

      before do
        component.type    = type
        component.filters = filters
        component.options = options
      end

      it { is_expected.to eq result }
    end
  end

  %i(from group group_each order select).each do |type|
    describe "#to_#{type}" do
      let(:filters) { [:column1, :column2, :column3] }
      let(:result) do
        format(described_class::TEMPLATE[type], filters.join(", "))
      end

      subject { component.send("to_#{type}") }

      before do
        component.type    = type
        component.filters = filters
      end

      it { is_expected.to eq result }
    end
  end

  %i(having omit_record_if where).each do |type|
    describe "#to_#{type}" do
      let(:filters) { ["(user_id = 3)", "OR", "(id = 5)"] }
      let(:result) do
        format(described_class::TEMPLATE[type], filters.join(" "))
      end

      subject { component.send("to_#{type}") }

      before do
        component.type    = type
        component.filters = filters
      end

      it { is_expected.to eq result }
    end
  end

  describe "#to_from_union_all_with_alias" do
    let(:type)    { :from_union_all_with_alias }
    let(:filters) { [:table1, :table2, :table3] }
    let(:options) { { as: :table } }
    let(:result) do
      format(described_class::TEMPLATE[type], filters.join(", "), options[:as])
    end

    before do
      component.type    = type
      component.filters = filters
      component.options = options
    end

    subject { component.send(:to_from_union_all_with_alias) }

    it { is_expected.to eq result }
  end

  describe "#to_limit" do
    let(:type)    { :limit }
    let(:filters) { [100] }
    let(:result) do
      format(described_class::TEMPLATE[type], filters.last)
    end

    before do
      component.type    = type
      component.filters = filters
    end

    subject { component.send(:to_limit) }

    it { is_expected.to eq result }
  end

  describe "#to_limit_with_offset" do
    let(:type)    { :limit_with_offset }
    let(:filters) { [100] }
    let(:options) { { offset: 10 } }
    let(:result) do
      format(described_class::TEMPLATE[type], filters.last, options[:offset])
    end

    before do
      component.type    = type
      component.filters = filters
      component.options = options
    end

    subject { component.send(:to_limit_with_offset) }

    it { is_expected.to eq result }
  end
end
