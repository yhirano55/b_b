module BB
  class Relation
    extend Forwardable
    attr_reader :builder

    def initialize
      @builder = Builder.new
    end

    def_delegator(:builder, :build)
    alias_method(:to_sql, :build)

    API[:basic].each do |name|
      define_method(name) do |*args|
        raise ArgumentError, "wrong number of arguments ##{__method__} (at least 1)" if args.empty?

        tap { builder.assign(name).append_formatted_filters(args) }
      end
    end

    API[:joins].each do |name|
      define_method(name) do |*args|
        raise ArgumentError, "wrong number of arguments ##{__method__} (at least 1)" if args.empty?

        tap { builder.append_joins(name).append_formatted_filters(args) }
      end
    end

    def and
      tap { builder.options[:operator] = "AND" }
    end

    def or
      tap { builder.options[:operator] = "OR" }
    end

    def not
      tap { builder.options[:negation] = true }
    end

    def on(rel)
      tap { builder.add_option_to_just_before_join(rel) }
    end

    def offset(offset)
      tap { builder.add_offset_to_limit(offset) }
    end
  end
end
