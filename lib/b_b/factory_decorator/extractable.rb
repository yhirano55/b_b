module BB
  module FactoryDecorator
    module Extractable
      OPERATOR = { and: "AND", or: "OR" }.freeze

      private

      def extract_options!(args)
        return unless args.last.is_a?(Hash)

        if args.size > 2
          super
        else
          extracted_options = {
            negation: args.last.delete(:negation),
            operator: args.last.delete(:operator),
            reduce:   args.last.delete(:reduce)
          }.reject { |_k, v| v.nil? }

          options.merge!(extracted_options)
        end
      end

      def format_filters(expressions)
        append_operator

        condition = case type_of_expressions(expressions)
                    when :with_args   then format_condition_by_args(base_string: expressions.shift, args: expressions)
                    when :with_params then format_condition_by_params(base_string: expressions[0], params: expressions[1])
                    else expressions.map(&method(:format_condition)).compact.join(concat_operator)
                    end

        [] << format("(%s)", condition)
      end

      def append_operator
        return if filters.empty?

        filters << (options.delete(:operator) || OPERATOR[:and])
      end

      def type_of_expressions(expressions)
        return :with_args   if expressions[0].is_a?(String) && expressions[0].include?("?") && !expressions[1].is_a?(Hash)
        return :with_params if expressions[0].is_a?(String) && expressions[0].include?(":") && expressions[1].is_a?(Hash)
      end

      def format_condition_by_args(base_string: "", args: [])
        formatted_base_string = base_string.gsub(/\?/, "%s")
        formatted_args = args.map { |v| Converter::Value.convert(v) }
        format(formatted_base_string, *formatted_args)
      end

      def format_condition_by_params(base_string: "", params: {})
        params.each { |k, v| base_string.gsub!(/:#{k}/, Converter::Value.convert(v)) }
        base_string
      end

      def format_condition(value)
        negation = options.delete(:negation)

        if value.is_a?(Hash)
          value.map do |col, val|
            Converter::Formula.convert(col, val, negation: negation)
          end
        elsif (value.is_a?(String) && !value.empty?) || value.is_a?(Symbol)
          value.to_s
        end
      end

      def concat_operator
        format(" %s ", options.delete(:reduce).to_s.upcase == OPERATOR[:or] ? OPERATOR[:or] : OPERATOR[:and])
      end
    end
  end
end
