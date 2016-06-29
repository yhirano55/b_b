require "spec_helper"

RSpec.describe "From Clause" do
  describe "One Table Listed in the FROM Clause" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        suppliers
      WHERE
        (supplier_id < 400)
      ORDER BY
        city DESC
      SQL
    end

    subject do
      BB.from(:suppliers).
        where(supplier_id_lt: 400).
        order(city: :desc).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Two Tables in the FROM Clause (INNER JOIN)" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        products.product_name,
        categories.category_name
      FROM
        products AS products
      INNER JOIN
        categories AS categories
      ON
        products.category_id = categories.category_id
      WHERE
        (product_name <> 'Pear')
      SQL
    end

    subject do
      BB.select("products.product_name, categories.category_name").
        from(:products, as: :products).
        inner_join(:categories, as: :categories).
        on("products.category_id = categories.category_id").
        where(product_name_not_eq: "Pear").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Two Tables in the FROM Clause (OUTER JOIN)" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        products.product_name,
        categories.category_name
      FROM
        products AS products
      LEFT OUTER JOIN
        categories AS categories
      ON
        products.category_id = categories.category_id
      WHERE
        (product_name <> 'Pear')
      SQL
    end

    subject do
      BB.select("products.product_name, categories.category_name").
        from(:products, as: :products).
        left_outer_join(:categories, as: :categories).
        on("products.category_id = categories.category_id").
        not.where(product_name: "Pear").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Many Tables in the FROM Clause (UNION ALL)" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        FORMAT_UTC_USEC(event.timestamp_in_usec) AS time,
        request_url
      FROM
        [applogs.events_20120501],
        [applogs.events_20120502],
        [applogs.events_20120503]
      WHERE
        (event.username = 'root' AND NOT event.source_ip.is_internal)
      SQL
    end

    subject do
      BB.select("FORMAT_UTC_USEC(event.timestamp_in_usec) AS time, request_url").
        from("[applogs.events_20120501]", "[applogs.events_20120502]", "[applogs.events_20120503]").
        where("event.username = ? AND NOT event.source_ip.is_internal", "root").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "TABLE_DATE_RANGE function in the FROM Clause" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        name
      FROM
        TABLE_DATE_RANGE(mydata.people, TIMESTAMP('2014-03-25'), TIMESTAMP('2014-03-27'))
      WHERE
        (age >= 35)
      SQL
    end

    subject do
      BB.select(:name).
        from("mydata.people", from: Date.new(2014, 3, 25), to: Date.new(2014, 3, 27)).
        where(age_gteq: 35).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "TABLE_DATE_RANGE function in the FROM Clause (with UNION ALL)" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        name
      FROM
        [mydata.people20160401],
        (
          SELECT
            *
          FROM
            TABLE_DATE_RANGE(mydata.people, TIMESTAMP('2014-03-25'), TIMESTAMP('2014-03-27'))
        ),
        (
          SELECT
            *
          FROM
            TABLE_DATE_RANGE(mydata.people, TIMESTAMP('2013-03-25'), TIMESTAMP('2013-03-27'))
        )
      WHERE
        (age >= 35)
      SQL
    end

    subject do
      BB.select(:name).
        from(
          "[mydata.people20160401]",
          BB.from("mydata.people", from: Date.new(2014, 3, 25), to: Date.new(2014, 3, 27)),
          BB.from("mydata.people", from: Date.new(2013, 3, 25), to: Date.new(2013, 3, 27))
        ).
        where(age_gteq: 35).
        to_sql
    end

    it { is_expected.to eq sql }
  end
end
