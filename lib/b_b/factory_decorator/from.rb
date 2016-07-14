module BB
  module FactoryDecorator
    module From
      private

      def format_filters(expressions)
        expressions.map(&method(:format_condition)).compact
      end

      def format_condition(value)
        Converter::Table.convert(value, options.dup)
      end

      def format_type_of_component
        if options.key?(:as) && filters.size > 1
          :from_union_all_with_alias
        elsif options.key?(:as) && filters.size == 1
          :from_with_alias
        else
          :from
        end
      end
    end
  end
end
