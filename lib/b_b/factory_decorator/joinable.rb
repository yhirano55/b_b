module BB
  module FactoryDecorator
    module Joinable
      private

      def format_filters(expressions)
        expressions.map(&method(:format_condition)).compact
      end

      def format_condition(value)
        Converter::Table.convert(value, options.dup)
      end
    end
  end
end
