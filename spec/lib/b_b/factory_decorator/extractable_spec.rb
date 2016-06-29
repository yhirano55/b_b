require "spec_helper"

describe BB::FactoryDecorator::Extractable do
  let(:factory) { BB::Factory.new.extend(described_class) }

  describe "#extract_options!" do
    subject { factory.send(:extract_options!, args) }

    context "when args.size > 2" do
      let(:options) { { key: :value } }
      let(:args) { [1, 2, 3, options] }

      it "should extract options" do
        is_expected.to eq options
      end
    end

    context "when args.size <= 2" do
      let(:options) { { negation: true } }
      let(:args) { ["id = :id", { id: 123 }.merge(options)] }

      it "should extract options" do
        is_expected.to eq options
      end
    end
  end

  describe "#format_filters" do
    subject { factory.send(:format_filters, expressions.dup) }

    context "when type of expressions is :with_args" do
      let(:expressions) { ["id = ? AND name = ?", 123, "Jack"] }
      let(:result) do
        condition = factory.send(:format_condition_by_args, base_string: expressions.shift, args: expressions)
        [] << format("(%s)", condition)
      end

      it { is_expected.to eq result }
    end

    context "when type of expressions is :with_params" do
      let(:expressions) { ["id = :id AND name = :name", { id: 123, name: "Jack" }] }
      let(:result) do
        condition = factory.send(:format_condition_by_params, base_string: expressions[0], params: expressions[1])
        [] << format("(%s)", condition)
      end

      it { is_expected.to eq result }
    end

    context "when type of expressions is not :with_args or :with_params" do
      let(:expressions) { [{ id: 123, name: "Jack" }] }
      let(:result) do
        condition = expressions.map { |value| factory.send(:format_condition, value) }.compact.uniq.join(factory.send(:concat_operator))

        [] << format("(%s)", condition)
      end

      it { is_expected.to eq result }
    end
  end

  describe "#append_operator" do
    subject { factory.send(:append_operator) }

    context "when filters are not empty" do
      context "when options[:operator] is present" do
        before do
          factory.filters = ["id = 1"]
          factory.options = { operator: :AND }
        end

        it "should append operator to filters" do
          is_expected.to match_array factory.filters
        end
      end

      context "when options[:operator] is blank" do
        before do
          factory.filters = ["id = 1"]
        end

        it "should append operator to filters" do
          is_expected.to match_array factory.filters
        end
      end
    end

    context "when filters are empty" do
      it { is_expected.to be_nil }
    end
  end

  describe "#format_condition_by_args" do
    let(:base_string) { "id = ? AND name = ?" }
    let(:args) { [123, "Jack"] }
    let(:result) do
      formatted_base_string = base_string.gsub(/\?/, "%s")
      formatted_args = args.map { |v| BB::Converter::Value.convert(v) }
      format(formatted_base_string, *formatted_args)
    end

    subject do
      factory.send(:format_condition_by_args, base_string: base_string, args: args)
    end

    it { is_expected.to eq result }
  end

  describe "#format_condition_by_params" do
    let(:base_string) { "id = :id AND name = :name" }
    let(:params) do
      { id: 123, name: "Jack" }
    end
    let(:result) do
      params.each do |k, v|
        base_string.gsub!(/:#{k}/, BB::Converter::Value.convert(v))
      end

      base_string
    end

    subject do
      factory.send(:format_condition_by_params, base_string: base_string, params: params)
    end

    it { is_expected.to eq result }
  end

  describe "#format_condition" do
    subject { factory.send(:format_condition, value) }

    context "when value is kind of Hash" do
      let(:value) { { id: 123, name: "Jack" } }
      let(:result) do
        value.map do |col, val|
          BB::Converter::Formula.convert(col, val)
        end
      end

      it { is_expected.to eq result }
    end

    context "when value is kind of String or Symbol" do
      let(:value) { :symbol }
      let(:result) { value.to_s }

      it { is_expected.to eq result }
    end
  end

  describe "#concat_operator" do
    subject { factory.send(:concat_operator) }

    context "when options[:reduce] is present" do
      context "when options[:reduce] equals OPERATOR[:or]" do
        let(:result) do
          format(" %s ", described_class::OPERATOR[:or])
        end

        before do
          factory.options[:reduce] = described_class::OPERATOR[:or]
        end

        it { is_expected.to eq result }
      end

      context "when options[:reduce] not equals OPERATOR[:or]" do
        let(:result) do
          format(" %s ", described_class::OPERATOR[:and])
        end

        before do
          factory.options[:reduce] = "wrong operator"
        end

        it { is_expected.to eq result }
      end
    end

    context "when options[:reduce] is blank" do
      let(:result) do
        format(" %s ", described_class::OPERATOR[:and])
      end

      it { is_expected.to eq result }
    end
  end
end
