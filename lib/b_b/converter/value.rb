module BB
  module Converter
    class Value
      TEMPLATE = {
        array:     "(%s)",
        date:      "DATE('%Y-%m-%d')",
        null:      "NULL",
        range:     "%s AND %s",
        regexp:    "r'%s'",
        string:    "'%s'",
        subquery:  "(%s)",
        time:      "TIMESTAMP('%Y-%m-%d %H:%M:%S')",
        timestamp: "TIMESTAMP('%Y-%m-%d')"
      }.freeze

      attr_reader :value, :options, :type

      def initialize(value, options = {})
        @value   = value
        @options = options
        @type    = format_type
      end

      def convert
        send("to_#{type}")
      end

      private

      def format_type
        options[:type] || Evaluator::Value.eval_type(value, options)
      end

      def to_array
        format(TEMPLATE[:array], value.map(&method(:convert_member_value)).join(", "))
      end

      def to_boolean
        value.to_s
      end

      alias_method(:to_numeric, :to_boolean)

      def to_date
        value.strftime(TEMPLATE[:date])
      end

      def to_time
        value.strftime(TEMPLATE[:time])
      end

      def to_timestamp
        value.strftime(TEMPLATE[:timestamp])
      end

      def to_null
        TEMPLATE[:null]
      end

      def to_range
        range_values = extract_range_values(value).map(&method(:convert_member_value))
        format(TEMPLATE[:range], range_values[0], range_values[1])
      end

      def to_regexp
        format(TEMPLATE[:regexp], value.inspect[1..-2])
      end

      def to_string
        format(TEMPLATE[:string], value)
      end

      def to_subquery
        format(TEMPLATE[:subquery], value.to_sql)
      end

      def convert_member_value(value)
        self.class.convert(value, eval_types: %i(boolean date null numeric string time))
      end

      def extract_range_values(value)
        [].tap do |arr|
          arr << value.begin
          arr << if value.exclude_end?
                   (!value.end.is_a?(Time) ? value.last(1)[0] : value.last - 1)
                 else
                   value.end
                 end
        end
      end

      class << self
        def convert(value, options = {})
          new(value, options).convert
        end
      end
    end
  end
end
