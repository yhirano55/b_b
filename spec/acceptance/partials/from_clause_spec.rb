require "spec_helper"

RSpec.describe "Partial of From Clause" do
  describe "plain" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        suppliers
      SQL
    end

    subject do
      BB.from(:suppliers).to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "table date" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        suppliers20170101
      SQL
    end

    subject do
      BB.from(:suppliers, on: Date.new(2017, 1, 1)).to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "table date range" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        TABLE_DATE_RANGE(suppliers, TIMESTAMP('2017-01-01'), TIMESTAMP('2017-01-05'))
      SQL
    end

    subject do
      BB.from(:suppliers, from: Date.new(2017, 1, 1), to: Date.new(2017, 1, 5)).to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "subquery" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
      (
        SELECT
          *
        FROM
          suppliers
      )
      SQL
    end

    subject do
      BB.from(BB.from(:suppliers)).to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "union" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        table1,
        table2,
        table3
      SQL
    end

    subject do
      BB.from(:table1, :table2, :table3).to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "union contains table_date" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        alice20170101,
        bob20170101,
        carol20170101
      SQL
    end

    subject do
      BB.from(:alice, :bob, :carol, on: Date.new(2017, 1, 1)).to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "union contains table_date_range" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        (SELECT * FROM TABLE_DATE_RANGE(alice, TIMESTAMP('2017-01-01'), TIMESTAMP('2017-01-05'))),
        (SELECT * FROM TABLE_DATE_RANGE(bob, TIMESTAMP('2017-01-01'), TIMESTAMP('2017-01-05'))),
        (SELECT * FROM TABLE_DATE_RANGE(carol, TIMESTAMP('2017-01-01'), TIMESTAMP('2017-01-05')))
      SQL
    end

    subject do
      BB.from(
        BB.from(:alice, from: Date.new(2017, 1, 1), to: Date.new(2017, 1, 5)),
        BB.from(:bob,   from: Date.new(2017, 1, 1), to: Date.new(2017, 1, 5)),
        BB.from(:carol, from: Date.new(2017, 1, 1), to: Date.new(2017, 1, 5))
      ).to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "union contains subquery" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        table1,
        table2,
        (SELECT * FROM table3)
      SQL
    end

    subject do
      BB.from(:table1, :table2, BB.from(:table3)).to_sql
    end

    it { is_expected.to eq sql }
  end
end
