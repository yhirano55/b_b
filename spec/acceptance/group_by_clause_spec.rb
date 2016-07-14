require "spec_helper"

RSpec.describe "GROUP BY Clause" do
  describe "Using GROUP BY with the SUM Function" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        dept_id,
        SUM(salary) AS total_salaries
      FROM
        employees
      GROUP BY
        dept_id
      SQL
    end

    subject do
      BB.select(:dept_id, "SUM(salary) AS total_salaries").
        from(:employees).
        group(:dept_id).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Using GROUP BY with the COUNT function" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        category_id,
        COUNT(*) AS total_products
      FROM
        products
      WHERE
        (category_id IS NOT NULL)
      GROUP BY
        category_id
      ORDER BY
        category_id
      SQL
    end

    subject do
      BB.select(:category_id, "COUNT(*) AS total_products").
        from(:products).
        where(category_id_not_eq: nil).
        group(:category_id).
        order(:category_id).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Using GROUP BY with the MAX function" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        dept_id,
        MAX(salary) AS highest_salary
      FROM
        employees
      GROUP BY
        dept_id
      SQL
    end

    subject do
      BB.select(:dept_id, "MAX(salary) AS highest_salary").
        from(:employees).
        group(:dept_id).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Using GROUP EACH BY" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        first,
        COUNT(ngram)
      FROM
        publicdata:samples.trigrams
      GROUP EACH BY
        1
      ORDER BY
        2 DESC
      LIMIT
        10
      SQL
    end

    subject do
      BB.select(:first, "COUNT(ngram)").
        from("publicdata:samples.trigrams").
        group_each("1").
        order("2" => :desc).
        limit(10).
        to_sql
    end

    it { is_expected.to eq sql }
  end
end
