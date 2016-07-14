module BB
  class Component
    TEMPLATE = {
      cross_join:                "CROSS JOIN %s AS %s",
      from:                      "FROM %s",
      from_union_all_with_alias: "FROM (SELECT * FROM %s) AS %s",
      from_with_alias:           "FROM %s AS %s",
      full_outer_join_each:      "FULL OUTER JOIN EACH %s AS %s ON %s",
      group:                     "GROUP BY %s",
      group_each:                "GROUP EACH BY %s",
      having:                    "HAVING %s",
      inner_join:                "INNER JOIN %s AS %s ON %s",
      inner_join_each:           "INNER JOIN EACH %s AS %s ON %s",
      join:                      "JOIN %s AS %s ON %s",
      join_each:                 "JOIN EACH %s AS %s ON %s",
      left_join:                 "LEFT JOIN %s AS %s ON %s",
      left_join_each:            "LEFT JOIN EACH %s AS %s ON %s",
      left_outer_join:           "LEFT OUTER JOIN %s AS %s ON %s",
      left_outer_join_each:      "LEFT OUTER JOIN EACH %s AS %s ON %s",
      limit:                     "LIMIT %d",
      limit_with_offset:         "LIMIT %d OFFSET %d",
      omit_record_if:            "OMIT RECORD IF %s",
      order:                     "ORDER BY %s",
      right_join:                "RIGHT JOIN EACH %s AS %s ON %s",
      right_join_each:           "RIGHT JOIN EACH %s AS %s ON %s",
      right_outer_join:          "RIGHT OUTER JOIN EACH %s AS %s ON %s",
      right_outer_join_each:     "RIGHT OUTER JOIN EACH %s AS %s ON %s",
      select:                    "SELECT %s",
      where:                     "WHERE %s"
    }.freeze

    attr_accessor :filters, :options, :type

    def initialize
      @filters = []
      @options = {}
    end

    def build
      type && send("to_#{type}")
    end

    private

    (API[:joins] - [:to_cross_join]).each do |name|
      define_method("to_#{name}") do
        format(TEMPLATE[name.to_sym], filters[0], options[:as], options[:rel])
      end
    end

    %i(cross_join from_with_alias).each do |name|
      define_method("to_#{name}") do
        format(TEMPLATE[name.to_sym], filters[0], options[:as])
      end
    end

    %i(from group group_each order select).each do |name|
      define_method("to_#{name}") do
        format(TEMPLATE[name.to_sym], filters.join(", "))
      end
    end

    %i(having omit_record_if where).each do |name|
      define_method("to_#{name}") do
        format(TEMPLATE[name.to_sym], filters.join(" "))
      end
    end

    def to_from_union_all_with_alias
      format(TEMPLATE[:from_union_all_with_alias], filters.join(", "), options[:as])
    end

    def to_limit
      format(TEMPLATE[:limit], filters.last)
    end

    def to_limit_with_offset
      format(TEMPLATE[:limit_with_offset], filters.last, options[:offset])
    end
  end
end
