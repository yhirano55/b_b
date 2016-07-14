module BB
  module Converter
    class Table
      TEMPLATE = {
        subquery: "(%s)",
        table_date_range: "TABLE_DATE_RANGE(%s, %s, %s)"
      }.freeze

      attr_reader :value, :options

      def initialize(value, options = {})
        @value   = value
        @options = options
      end

      def convert
        evaluated_type = Evaluator::Table.eval_type(value, options)
        evaluated_type && send("to_#{evaluated_type}")
      end

      private

      def to_subquery
        format(TEMPLATE[:subquery], value.to_sql)
      end

      def to_table_date
        options[:on].strftime("#{value}%Y%m%d")
      end

      def to_table_date_range
        from = Value.convert(options[:from], type: :timestamp)
        to   = Value.convert(options[:to],   type: :timestamp)

        format(TEMPLATE[:table_date_range], value, from, to)
      end

      def to_plain
        value.to_s
      end

      class << self
        def convert(value, options = {})
          new(value, options).convert
        end
      end
    end
  end
end
