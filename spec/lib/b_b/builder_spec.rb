require "spec_helper"

describe BB::Builder do
  let(:builder) { described_class.new }

  describe "#build" do
    subject { builder.build }

    context "when assigned builder" do
      before do
        builder.assign(:from).append_formatted_filters(["[table]"])
      end

      let(:result) { "SELECT * FROM [table]" }

      it { is_expected.to eq result }
    end

    context "when not assigned builder" do
      it { is_expected.to be_empty }
    end
  end

  describe "#assign" do
    let(:name) { :from }

    subject { builder.assign(name) }

    it { is_expected.to be_instance_of(BB::Factory) }
  end

  describe "#append_joins" do
    let(:name) { :inner_join }

    subject { builder.append_joins(name) }

    it { is_expected.to be_instance_of(BB::Factory) }
  end

  describe "#add_option_to_just_before_join" do
    let(:expression) { "t1.id = t2.id" }

    subject { builder.add_option_to_just_before_join(expression) }

    context "when joins are present" do
      before do
        builder.append_joins(:inner_join).append_formatted_filters([:table, { as: :table }])
      end

      it "should set option to just before join factory" do
        is_expected.to eq expression
        expect(builder.joins.last.options.key?(:rel)).to be true
      end
    end

    context "when joins are blank" do
      it { is_expected.to be_nil }
    end
  end

  describe "#add_offset_to_limit" do
    let(:offset) { 100 }

    subject { builder.add_offset_to_limit(offset) }

    context "when limit is present" do
      before do
        builder.assign(:limit).append_formatted_filters([1000])
      end

      it "should set option to limit" do
        is_expected.to eq offset
        expect(builder.limit.options.key?(:offset)).to be true
      end
    end

    context "when limit is blank" do
      it { is_expected.to be_nil }
    end
  end

  describe "#structure" do
    let(:structure) do
      [
        builder.send(:select_clause),
        builder.from,
        builder.joins,
        builder.omit_record_if,
        builder.where,
        builder.send(:group_clause),
        builder.having,
        builder.order,
        builder.limit
      ]
    end

    subject { builder.send(:structure) }

    it "should return structure" do
      is_expected.to eq structure
    end
  end

  describe "#select_clause" do
    subject { builder.send(:select_clause) }

    context "when builder have already assigned :select" do
      let(:result) { builder.select }

      before do
        builder.assign(:select).append_formatted_filters(%w(col1 col2 col3))
      end

      it { is_expected.to be result }
    end

    context "when builder have assigned :from" do
      before do
        builder.assign(:from).append_formatted_filters(%w(table))
      end

      it { is_expected.to be_an_instance_of(BB::Factory) }
    end

    context "when builder have not assigned :select, :from" do
      it { is_expected.to be_nil }
    end
  end

  describe "#group_clause" do
    subject { builder.send(:group_clause) }

    context "when builder have assigned :group" do
      before do
        builder.assign(:group).append_formatted_filters(%w(col1 col2 col3))
      end

      it { is_expected.to be builder.group }
    end

    context "when builder have assigned :group_each" do
      before do
        builder.assign(:group_each).append_formatted_filters(%w(col1 col2 col3))
      end

      it { is_expected.to be builder.group_each }
    end

    context "when builder have assigned :group and :group_each" do
      before do
        builder.assign(:group).append_formatted_filters(%w(col1 col2 col3))
        builder.assign(:group_each).append_formatted_filters(%w(col1 col2 col3))
      end

      it { is_expected.to be builder.group }
    end

    context "when builder have not assigned :group and :group_each" do
      it { is_expected.to be_nil }
    end
  end

  describe "#get_factory_ivar" do
    let(:name) { :from }

    subject { builder.send(:get_factory_ivar, name) }

    it { is_expected.to be_an_instance_of(BB::Factory) }
  end

  describe "#set_factory_ivar" do
    let(:name) { :from }

    subject { builder.send(:set_factory_ivar, name) }

    it { is_expected.to be_an_instance_of(BB::Factory) }
  end

  describe "#append_options!" do
    before do
      builder.assign(:from).append_formatted_filters([%w(table)])
    end

    subject { builder.send(:append_options!, builder.from) }

    context "when options are present" do
      before do
        builder.options[:as] = :table
      end

      it "should set options to factory and clear builder options" do
        subject
        expect(builder.from.options.key?(:as)).to be true
        expect(builder.options).to be_empty
      end
    end

    context "when options are blank" do
      it { is_expected.to be_nil }
    end
  end

  describe "#register_factory" do
    let(:name) { :from }

    subject { builder.send(:register_factory, name) }

    it { is_expected.to be_an_instance_of(BB::Factory) }
  end
end
