require "spec_helper"

RSpec.describe "Select Statement" do
  describe "Select All Fields from a Table" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        customers
      WHERE
        (favorite_website = 'techonthenet.com')
      ORDER BY
        last_name ASC
      SQL
    end

    subject do
      BB.from(:customers).
        where(favorite_website: "techonthenet.com").
        order(last_name: :asc).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Select Individual Fields from a Table" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        supplier_name,
        city
      FROM
        suppliers
      WHERE
        (supplier_id > 500)
      ORDER BY
        supplier_name ASC,
        city DESC
      SQL
    end

    subject do
      BB.select(:supplier_name, :city).
        from(:suppliers).
        where(supplier_id_gt: 500).
        order(supplier_name: :asc, city: :desc).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Select Individual Fields From Multiple Tables" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        orders.order_id,
        customers.last_name
      FROM
        orders AS others
      INNER JOIN
        customers AS customers
      ON
        orders.customer_id = customers.customer_id
      WHERE
        (orders.order_id <> 1)
      ORDER BY
        orders.order_id
      SQL
    end

    subject do
      BB.select("orders.order_id", "customers.last_name").
        from(:orders, as: :others).
        inner_join(:customers, as: :customers).
        on("orders.customer_id = customers.customer_id").
        where("orders.order_id <> ?", 1).
        order("orders.order_id").
        to_sql
    end

    it { is_expected.to eq sql }
  end
end
