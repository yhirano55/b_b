require "spec_helper"

RSpec.describe "ORDER BY Clause" do
  describe "Sorting Results in Ascending Order" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        customers
      ORDER BY
        last_name
      SQL
    end

    subject do
      BB.from(:customers).
        order(:last_name).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Sorting Results in descending order" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        suppliers
      WHERE
        (supplier_id > 400)
      ORDER BY
        supplier_id DESC
      SQL
    end

    subject do
      BB.from(:suppliers).
        where("supplier_id > :amount", amount: 400).
        order(supplier_id: :desc).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Sorting Results by relative position" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        product_id,
        product_name
      FROM
        products
      WHERE
        (product_name <> 'Bread')
      ORDER BY
        1 DESC
      SQL
    end

    subject do
      BB.select(:product_id, :product_name).
        from(:products).
        where(product_name_not_eq: "Bread").
        order("1" => :desc).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Using both ASC and DESC attributes" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        products
      WHERE
        (product_id <> 7)
      ORDER BY
        category_id DESC,
        product_name ASC
      SQL
    end

    subject do
      BB.from(:products).
        where(product_id_not_eq: 7).
        order(category_id: :desc, product_name: :asc).
        to_sql
    end

    it { is_expected.to eq sql }
  end
end
