module BB
  module Converter
    class Formula
      TEMPLATE = {
        between:      "%s BETWEEN %s",
        contains:     "%s CONTAINS %s",
        equals:       "%s = %s",
        gt:           "%s > %s",
        gteq:         "%s >= %s",
        in:           "%s IN %s",
        is:           "%s IS %s",
        lt:           "%s < %s",
        lteq:         "%s <= %s",
        match:        "REGEXP_MATCH(%s, %s)",
        not_between:  "NOT %s BETWEEN %s",
        not_contains: "NOT %s CONTAINS %s",
        not_equals:   "%s <> %s",
        not_gt:       "NOT %s > %s",
        not_gteq:     "NOT %s >= %s",
        not_in:       "NOT %s IN %s",
        not_is:       "%s IS NOT %s",
        not_lt:       "NOT %s < %s",
        not_lteq:     "NOT %s <= %s",
        not_match:    "NOT REGEXP_MATCH(%s, %s)"
      }.freeze

      OPERATORS_DICTIONARY = {
        cont:         :contains,
        contains:     :contains,
        eq:           :equals,
        eql:          :equals,
        equals:       :equals,
        gt:           :gt,
        gteq:         :gteq,
        like:         :contains,
        lt:           :lt,
        lteq:         :lteq,
        not_cont:     :not_contains,
        not_contains: :not_contains,
        not_eq:       :not_equals,
        not_eql:      :not_equals,
        not_equals:   :not_equals,
        not_gt:       :not_gt,
        not_gteq:     :not_gteq,
        not_like:     :not_contains,
        not_lt:       :not_lt,
        not_lteq:     :not_lteq
      }.freeze

      SEARCHABLE_COLUMN_FORMAT = /(?:(\w+)_(not_\w+)|(\w+)_(\w+))/

      attr_reader :column, :operator, :value, :options

      def initialize(column, value, options = {})
        @column  = format_column(column)
        @value   = format_value(value)
        @options = options
      end

      def convert
        evaluated_type = Evaluator::Formula.eval_type(value, options.merge(operator: operator))
        evaluated_type && format(TEMPLATE[evaluated_type], column, value.convert)
      end

      private

      def format_column(column)
        scanned_column = column.to_s.scan(SEARCHABLE_COLUMN_FORMAT).flatten.compact
        !scanned_column.empty? && format_operator(scanned_column[1]) ? scanned_column[0] : column
      end

      def format_operator(operator)
        @operator = OPERATORS_DICTIONARY[operator.to_sym]
      end

      def format_value(value)
        value.is_a?(Value) ? value : Value.new(value)
      end

      class << self
        def convert(column, value, options = {})
          new(column, value, options).convert
        end
      end
    end
  end
end
