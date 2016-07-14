module BB
  module FactoryDecorator
    module Selectable
      private

      def format_filters(expressions)
        expressions.select(&method(:match?)).map(&:to_s)
      end

      def match?(value)
        (value.is_a?(String) && !value.empty?) || value.is_a?(Symbol)
      end
    end
  end
end
