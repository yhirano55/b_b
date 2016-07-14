module BB
  class Factory
    extend Forwardable

    attr_accessor :filters, :options, :type_of_component
    attr_reader :component

    def initialize
      @filters = []
      @options = {}
    end

    def_delegator(:component, :build)

    def append_formatted_filters(args)
      extract_options!(args)
      format_filters(args).each { |filter| filters << filter }
    end

    private

    # Override if you need
    def extract_options!(args)
      return unless args.size > 1 && args.last.is_a?(Hash)

      options.merge!(args.pop)
    end

    def format_filters(_expressions)
      raise NotImplementedError, "You must implemented #{self.class}##{__method__}"
    end

    def component
      @component ||= Component.new.tap do |component|
        component.filters = filters
        component.options = options
        component.type    = format_type_of_component
      end
    end

    # Override if you need
    def format_type_of_component
      type_of_component
    end

    class << self
      def build(name)
        decorator = FactoryDecorator.const_get(format_decorator_name(name))

        new.extend(decorator).tap do |factory|
          factory.type_of_component = name
        end
      end

      private

      def format_decorator_name(name)
        case name
        when :group, :group_each, :select     then :Selectable
        when :having, :omit_record_if, :where then :Extractable
        when *API[:joins]                     then :Joinable
        else name.to_s.scan(/[^-_]+/).map(&:capitalize).join.to_sym
        end
      end
    end
  end
end
