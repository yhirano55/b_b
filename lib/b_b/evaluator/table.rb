module BB
  module Evaluator
    class Table
      EVALUATE_TYPES = %i(subquery table_date table_date_range plain).freeze

      attr_reader :value, :options

      def initialize(value, options = {})
        @value   = value
        @options = options
      end

      def eval_type
        EVALUATE_TYPES.detect { |type| send("#{type}?") }
      end

      private

      def subquery?
        value.respond_to?(:to_sql)
      end

      def table_date?
        !value.to_s.empty? && options[:on].respond_to?(:strftime)
      end

      def table_date_range?
        !value.to_s.empty? && options[:from].respond_to?(:strftime) && options[:to].respond_to?(:strftime)
      end

      def plain?
        !value.to_s.empty? && !table_date? && !table_date_range? && !subquery?
      end

      class << self
        def eval_type(value, options = {})
          new(value, options).eval_type
        end
      end
    end
  end
end
