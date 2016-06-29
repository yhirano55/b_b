require "spec_helper"

describe BB::Relation do
  let(:relation) { described_class.new }

  %i(build to_sql).each do |method_name|
    describe "##{method_name}" do
      subject { relation.public_send(method_name) }

      it 'should call ##{method_name} through builder' do
        expect_any_instance_of(BB::Builder).to receive(:build).and_return(true)
        is_expected.to be true
      end
    end
  end

  BB::API[:basic].each do |method_name|
    describe "##{method_name}" do
      subject { relation.public_send(method_name, *args) }

      context "when args are present" do
        let(:args) { [%w(args)] }

        it "should return instance of BB::Relation" do
          factory = double("Factory")
          expect(relation.builder).to receive(:assign).and_return(factory).once
          expect(factory).to receive(:append_formatted_filters).once
          is_expected.to be_an_instance_of(described_class)
        end
      end

      context "when args are blank" do
        let(:args) { [] }

        it { expect { subject }.to raise_error(BB::ArgumentError, "wrong number of arguments ##{method_name} (at least 1)") }
      end
    end
  end

  BB::API[:joins].each do |method_name|
    describe "##{method_name}" do
      subject { relation.public_send(method_name, *args) }

      context "when args are present" do
        let(:args) { [%w(args)] }

        it "should return instance of BB::Relation" do
          factory = double("Factory")
          expect(relation.builder).to receive(:append_joins).and_return(factory).once
          expect(factory).to receive(:append_formatted_filters).once
          is_expected.to be_an_instance_of(described_class)
        end
      end

      context "when args are blank" do
        let(:args) { [] }

        it { expect { subject }.to raise_error(BB::ArgumentError, "wrong number of arguments ##{method_name} (at least 1)") }
      end
    end
  end

  describe "#and" do
    subject { relation.and }

    it "should return instance of BB::Relation" do
      is_expected.to be_an_instance_of(described_class)
      expect(relation.builder.options[:operator]).to eq "AND"
    end
  end

  describe "#or" do
    subject { relation.or }

    it "should return instance of BB::Relation" do
      is_expected.to be_an_instance_of(described_class)
      expect(relation.builder.options[:operator]).to eq "OR"
    end
  end

  describe "#not" do
    subject { relation.not }

    it "should return instance of BB::Relation" do
      is_expected.to be_an_instance_of(described_class)
      expect(relation.builder.options[:negation]).to be true
    end
  end

  describe "#on" do
    let(:rel) { "t1.id = t2.id" }

    subject { relation.on(rel) }

    it "should return instance of BB::Relation" do
      expect(relation.builder).to receive(:add_option_to_just_before_join).once
      is_expected.to be_an_instance_of(described_class)
    end
  end

  describe "#offset" do
    let(:offset) { 100 }

    subject { relation.offset(offset) }

    it "should return instance of BB::Relation" do
      expect(relation.builder).to receive(:add_offset_to_limit).once
      is_expected.to be_an_instance_of(described_class)
    end
  end
end
