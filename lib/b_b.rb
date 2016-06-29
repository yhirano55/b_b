require "date"
require "forwardable"

module BB
  autoload :VERSION,              "b_b/version"
  autoload :Builder,              "b_b/builder"
  autoload :Component,            "b_b/component"
  autoload :Converter,            "b_b/converter"
  autoload :Evaluator,            "b_b/evaluator"
  autoload :Factory,              "b_b/factory"
  autoload :FactoryDecorator,     "b_b/factory_decorator"
  autoload :Relation,             "b_b/relation"
  autoload :ArgumentError,        "b_b/exception"
  autoload :NotImplementedError,  "b_b/exception"
  autoload :UnevaluableTypeError, "b_b/exception"

  API = {
    basic: %i(
      from
      group
      group_each
      having
      limit
      omit_record_if
      order
      select
      where
    ),
    joins: %i(
      cross_join
      full_outer_join_each
      inner_join
      inner_join_each
      join
      join_each
      left_join
      left_join_each
      left_outer_join
      left_outer_join_each
      right_join
      right_join_each
      right_outer_join
      right_outer_join_each
    )
  }.freeze

  class << self
    def build
      relation = Relation.new
      yield(relation)
      relation.to_sql
    end

    def method_missing(name, *args)
      Relation.new.public_send(name, *args)
    end
  end
end
