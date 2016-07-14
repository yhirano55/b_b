require "spec_helper"

RSpec.describe "Partial of Where Clause" do
  describe "multiple chains" do
    let(:sql) do
      format_sql <<-SQL
      WHERE
        (a = 1 AND b = '2' AND c = 3)
      OR
        (a = 1 AND b = '2' AND c = 3)
      AND
        (a = 1 AND b = '2' AND c = 3)
      OR
        (a = 1 AND b = '2' AND c = 3)
      SQL
    end

    subject do
      BB.where("a = ? AND b = ? AND c = ?", 1, "2", 3).
        or.where("a = :a AND b = :b AND c = :c", a: 1, b: "2", c: 3).
        where(a: 1, b: "2", c: 3).
        or.where("a = 1", "b = '2'", "c = 3").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "multiple chains with negation option" do
    let(:sql) do
      format_sql <<-SQL
      WHERE
        (id = 1)
      AND
        (id = 1)
      AND
        (id <> 1)
      AND
        (id = 2)
      AND
        (id <> 3)
      SQL
    end

    subject do
      BB.where("id = ?", 1, negation: true).
        where("id = :id", id: 1, negation: true).
        where(id: 1, negation: true).
        where(id: 2, negation: false).
        where(id: 3, negation: true).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "multiple chains with reduce option" do
    let(:sql) do
      format_sql <<-SQL
      WHERE
        (id = 1 AND name = 'Jack')
      AND
        (id = 1 AND name = 'Jack')
      AND
        (id = 1 OR name = 'Jack')
      AND
        (id = 1 AND name = 'Jack')
      AND
        (id = 1 OR name = 'Jack')
      SQL
    end

    subject do
      BB.where("id = ? AND name = ?", 1, "Jack", reduce: :or).
        where("id = :id AND name = :name", id: 1, name: "Jack", reduce: :or).
        where(id: 1, name: "Jack", reduce: :or).
        where(id: 1, name: "Jack", reduce: :and).
        where(id: 1, name: "Jack", reduce: :or).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "search format" do
    let(:sql) do
      format_sql <<-SQL
      WHERE
        (
          c01 CONTAINS 'value'
          AND c02 CONTAINS 'value'
          AND c03 = 'value'
          AND c04 = 'value'
          AND c05 = 'value'
          AND c06 > 100
          AND c07 >= 100
          AND c08 CONTAINS 'value'
          AND c09 < 100
          AND c10 <= 100
          AND NOT c11 CONTAINS 'value'
          AND NOT c12 CONTAINS 'value'
          AND c13 <> 'value'
          AND c14 <> 'value'
          AND c15 <> 'value'
          AND NOT c16 > 100
          AND NOT c17 >= 100
          AND NOT c18 CONTAINS 'value'
          AND NOT c19 < 100
          AND NOT c20 <= 100
        )
      SQL
    end

    subject do
      BB.where(
        c01_cont:         "value",
        c02_contains:     "value",
        c03_eq:           "value",
        c04_eql:          "value",
        c05_equals:       "value",
        c06_gt:           100,
        c07_gteq:         100,
        c08_like:         "value",
        c09_lt:           100,
        c10_lteq:         100,
        c11_not_cont:     "value",
        c12_not_contains: "value",
        c13_not_eq:       "value",
        c14_not_eql:      "value",
        c15_not_equals:   "value",
        c16_not_gt:       100,
        c17_not_gteq:     100,
        c18_not_like:     "value",
        c19_not_lt:       100,
        c20_not_lteq:     100
      ).to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "search format (double negative)" do
    let(:sql) do
      format_sql <<-SQL
      WHERE
        (
          NOT c01 CONTAINS 'value'
          AND NOT c02 CONTAINS 'value'
          AND c03 <> 'value'
          AND c04 <> 'value'
          AND c05 <> 'value'
          AND NOT c06 > 100
          AND NOT c07 >= 100
          AND NOT c08 CONTAINS 'value'
          AND NOT c09 < 100
          AND NOT c10 <= 100
          AND c11 CONTAINS 'value'
          AND c12 CONTAINS 'value'
          AND c13 = 'value'
          AND c14 = 'value'
          AND c15 = 'value'
          AND c16 > 100
          AND c17 >= 100
          AND c18 CONTAINS 'value'
          AND c19 < 100
          AND c20 <= 100
        )
      SQL
    end

    subject do
      BB.not.where(
        c01_cont:         "value",
        c02_contains:     "value",
        c03_eq:           "value",
        c04_eql:          "value",
        c05_equals:       "value",
        c06_gt:           100,
        c07_gteq:         100,
        c08_like:         "value",
        c09_lt:           100,
        c10_lteq:         100,
        c11_not_cont:     "value",
        c12_not_contains: "value",
        c13_not_eq:       "value",
        c14_not_eql:      "value",
        c15_not_equals:   "value",
        c16_not_gt:       100,
        c17_not_gteq:     100,
        c18_not_like:     "value",
        c19_not_lt:       100,
        c20_not_lteq:     100
      ).to_sql
    end

    it { is_expected.to eq sql }
  end
end
