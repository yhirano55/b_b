require "spec_helper"

RSpec.describe "HAVING Clause" do
  describe "Using COUNT function" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        first,
        COUNT(ngram) ngram_count
      FROM
        publicdata:samples.trigrams
      GROUP BY
        1
      HAVING
        (first CONTAINS 'a' AND ngram_count < 10000)
      ORDER BY
        2 DESC
      LIMIT
        10
      SQL
    end

    subject do
      BB.select(:first, "COUNT(ngram) ngram_count").
        from("publicdata:samples.trigrams").
        group("1").
        having(first_cont: "a", ngram_count_lt: 10_000).
        order("2" => :desc).
        limit(10).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Using SUM function" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        department,
        SUM(sales) AS TotalSales
      FROM
        order_details
      GROUP BY
        department
      HAVING
        (SUM(sales) > 1000)
      SQL
    end

    subject do
      BB.select(:department, "SUM(sales) AS TotalSales").
        from(:order_details).
        group(:department).
        having("SUM(sales) > ?", 1000).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Using COUNT function" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        department,
        COUNT(*) AS NumberOfEmployees
      FROM
        employees
      WHERE
        (salary > 25000)
      GROUP BY
        department
      HAVING
        (COUNT(*) > 10)
      SQL
    end

    subject do
      BB.select(:department, "COUNT(*) AS NumberOfEmployees").
        from(:employees).
        where(salary_gt: 25_000).
        group(:department).
        having("COUNT(*) > ?", 10).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Using MIN function" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        department,
        MIN(salary) AS LowestSalary
      FROM
        employees
      GROUP BY
        department
      HAVING
        (MIN(salary) > 35000)
      SQL
    end

    subject do
      BB.select(:department, "MIN(salary) AS LowestSalary").
        from(:employees).
        group(:department).
        having("MIN(salary) > 35000").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Using MAX function" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        department,
        MAX(salary) AS HighestSalary
      FROM
        employees
      GROUP BY
        department
      HAVING
        (MAX(salary) < 50000)
      SQL
    end

    subject do
      BB.select(:department, "MAX(salary) AS HighestSalary").
        from(:employees).
        group(:department).
        having("MAX(salary) < ?", 50_000).
        to_sql
    end

    it { is_expected.to eq sql }
  end
end
