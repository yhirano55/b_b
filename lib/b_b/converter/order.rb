module BB
  module Converter
    class Order
      TEMPLATE = "%s %s".freeze

      attr_reader :column, :sort_key

      def initialize(column, options = {})
        @column   = column
        @sort_key = format_sort_key(options[:sort_key])
      end

      def convert
        format(TEMPLATE, column, sort_key)
      end

      private

      def format_sort_key(sort_key)
        sort_key.to_s.casecmp("DESC").zero? ? :DESC : :ASC
      end

      class << self
        def convert(column, options = {})
          new(column, options).convert
        end
      end
    end
  end
end
