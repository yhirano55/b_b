module BB
  module Evaluator
    class Value
      EVALUATE_TYPES = %i(array boolean date null numeric range regexp string subquery time).freeze

      attr_reader :value, :options

      def initialize(value, options = {})
        @value   = value
        @options = options
      end

      def eval_type
        eval_types.detect { |type| send("#{type}?") }.tap do |type|
          raise UnevaluableTypeError, "unevaluable type of value: #{value} (#{value.class})" if type.nil?
        end
      end

      private

      def eval_types
        options[:eval_types] || EVALUATE_TYPES
      end

      def array?
        value.is_a?(Array) && !value.empty?
      end

      def boolean?
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end

      def date?
        value.respond_to?(:strftime) && !value.respond_to?(:hour)
      end

      def null?
        value.nil?
      end

      def numeric?
        value.is_a?(Numeric)
      end

      def range?
        value.is_a?(Range) && !value.size.is_a?(Float)
      end

      def regexp?
        value.is_a?(Regexp)
      end

      def string?
        value.is_a?(String) || value.is_a?(Symbol)
      end

      def subquery?
        value.respond_to?(:to_sql)
      end

      def time?
        value.respond_to?(:strftime) && value.respond_to?(:hour)
      end

      class << self
        def eval_type(value, options = {})
          new(value, options).eval_type
        end
      end
    end
  end
end
