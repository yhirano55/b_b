module BB
  module FactoryDecorator
    module Limit
      private

      def format_filters(expressions)
        expressions.select(&method(:match?)).map(&:to_i)
      end

      def match?(value)
        value.respond_to?(:to_i) && !value.to_i.zero?
      end

      def format_type_of_component
        options.key?(:offset) ? :limit_with_offset : :limit
      end
    end
  end
end
