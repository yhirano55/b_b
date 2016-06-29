module BB
  class Builder
    attr_reader :from, :group, :group_each, :limit, :omit_record_if,
                :order, :select, :having, :where, :joins

    attr_accessor :options

    def initialize
      @joins   = []
      @options = {}
    end

    def build
      structure.flatten.compact.map(&:build).join(" ")
    end

    def assign(name)
      get_factory_ivar(name).tap do |factory|
        append_options!(factory)
      end
    end

    def append_joins(name)
      register_factory(name).tap do |factory|
        append_options!(factory)
        joins << factory
      end
    end

    def add_option_to_just_before_join(rel)
      return if joins.empty?

      joins.last.options[:rel] = rel
    end

    def add_offset_to_limit(offset)
      return if limit.nil?

      limit.options[:offset] = offset
    end

    private

    def structure
      [select_clause, from, joins, omit_record_if, where, group_clause, having, order, limit]
    end

    def select_clause
      select || unless from.nil?
                  get_factory_ivar(:select).tap do |factory|
                    factory.append_formatted_filters(%w(*))
                  end
                end
    end

    def group_clause
      group || group_each
    end

    def get_factory_ivar(name)
      instance_variable_get("@#{name}") || set_factory_ivar(name)
    end

    def set_factory_ivar(name)
      register_factory(name).tap do |factory|
        instance_variable_set("@#{name}", factory)
      end
    end

    def append_options!(factory)
      return if options.empty?

      factory.options.merge!(options)
      options.clear
    end

    def register_factory(name)
      Factory.build(name)
    end
  end
end
