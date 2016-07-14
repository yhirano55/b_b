require "spec_helper"

RSpec.describe "Partial of Joins" do
  describe "multiple joins" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        t1 AS t1
      INNER JOIN
        t2 AS t2
      ON
        t1.id = t2.id
      LEFT OUTER JOIN
        t3 AS t3
      ON
        t1.id = t3.id
      INNER JOIN
        t4 AS t4
      ON
        t3.id = t4.id
      SQL
    end

    subject do
      BB.from(:t1, as: :t1).
        inner_join(:t2, as: :t2).
        on("t1.id = t2.id").
        left_outer_join(:t3, as: :t3).
        on("t1.id = t3.id").
        inner_join(:t4, as: :t4).
        on("t3.id = t4.id").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "multiple joins contains table date" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        a AS t1
      INNER JOIN
        b20170101 AS t2
      ON
        t1.id = t2.id
      LEFT OUTER JOIN
        c20170101 AS t3
      ON
        t1.id = t3.id
      SQL
    end

    subject do
      BB.from(:a, as: :t1).
        inner_join(:b, on: Date.new(2017, 1, 1), as: :t2).
        on("t1.id = t2.id").
        left_outer_join(:c, on: Date.new(2017, 1, 1), as: :t3).
        on("t1.id = t3.id").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "multiple joins contains subquery" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        t1 AS t1
      INNER JOIN
        (SELECT * FROM t2) AS t2
      ON
        t1.id = t2.id
      LEFT OUTER JOIN
        (SELECT * FROM t3) AS t3
      ON
        t1.id = t3.id
      SQL
    end

    subject do
      BB.from(:t1, as: :t1).
        inner_join(BB.from(:t2), as: :t2).
        on("t1.id = t2.id").
        left_outer_join(BB.from(:t3), as: :t3).
        on("t1.id = t3.id").
        to_sql
    end

    it { is_expected.to eq sql }
  end
end
