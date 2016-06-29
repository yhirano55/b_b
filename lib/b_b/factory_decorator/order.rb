module BB
  module FactoryDecorator
    module Order
      private

      def format_filters(expressions)
        expressions.map(&method(:format_condition)).compact
      end

      def format_condition(value)
        if value.is_a?(Hash)
          value.map do |column, sort_key|
            Converter::Order.convert(column, sort_key: sort_key)
          end.join(", ")
        elsif (value.is_a?(String) && !value.empty?) || value.is_a?(Symbol)
          value.to_s
        end
      end
    end
  end
end
