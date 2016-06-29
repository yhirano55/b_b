require "spec_helper"

RSpec.describe "Joins" do
  describe "INNER JOIN (simple join)" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        customers.customer_id,
        orders.order_id,
        orders.order_date
      FROM
        customers AS customers
      INNER JOIN
        orders AS orders
      ON
        customers.customer_id = orders.customer_id
      ORDER BY
        customers.customer_id
      SQL
    end

    subject do
      BB.select("customers.customer_id", "orders.order_id", "orders.order_date").
        from(:customers, as: :customers).
        inner_join(:orders, as: :orders).
        on("customers.customer_id = orders.customer_id").
        order("customers.customer_id").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "LEFT OUTER JOIN" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        customers.customer_id,
        orders.order_id,
        orders.order_date
      FROM
        customers AS customers
      LEFT OUTER JOIN
        orders AS orders
      ON
        customers.customer_id = orders.customer_id
      ORDER BY
        customers.customer_id
      SQL
    end

    subject do
      BB.select("customers.customer_id", "orders.order_id", "orders.order_date").
        from(:customers, as: :customers).
        left_outer_join(:orders, as: :orders).
        on("customers.customer_id = orders.customer_id").
        order("customers.customer_id").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "RIGHT OUTER JOIN" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        customers.customer_id,
        orders.order_id,
        orders.order_date
      FROM
        customers AS customers
      RIGHT OUTER JOIN EACH
        orders AS orders
      ON
        customers.customer_id = orders.customer_id
      ORDER BY
        customers.customer_id
      SQL
    end

    subject do
      BB.select("customers.customer_id", "orders.order_id", "orders.order_date").
        from(:customers, as: :customers).
        right_outer_join_each(:orders, as: :orders).
        on("customers.customer_id = orders.customer_id").
        order("customers.customer_id").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "FULL OUTER JOIN" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        customers.customer_id,
        orders.order_id,
        orders.order_date
      FROM
        customers AS customers
      FULL OUTER JOIN EACH
        orders AS orders
      ON
        customers.customer_id = orders.customer_id
      ORDER BY
        customers.customer_id
      SQL
    end

    subject do
      BB.select("customers.customer_id", "orders.order_id", "orders.order_date").
        from(:customers, as: :customers).
        full_outer_join_each(:orders, as: :orders).
        on("customers.customer_id = orders.customer_id").
        order("customers.customer_id").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "CROSS JOIN" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        STRFTIME_UTC_USEC(a.ending_at, "%Y-%m-%d") ending_at1,
        STRFTIME_UTC_USEC(b.ending_at-60*86400000000, "%Y-%m-%d") starting_at2,
        STRFTIME_UTC_USEC(b.ending_at, "%Y-%m-%d") ending_at2,
        a.country,
        b.country,
        CORR(a.c, b.c) corr,
        COUNT(*) c
      FROM
      (
        SELECT
          country,
          date+i*86400000000 ending_at,
          c,
          i
        FROM
          [gdelt-bq:sample_views.country_date_matconf_numarts] AS a
        CROSS JOIN
        (
          SELECT
            i
          FROM
            [fh-bigquery:public_dump.numbers_255]
          WHERE
            (i < 60)
        ) AS b
      ) AS b
      JOIN
      (
        SELECT
          country,
          date+i*86400000000 ending_at,
          c,
          i
        FROM
          [gdelt-bq:sample_views.country_date_matconf_numarts] AS a
        CROSS JOIN
        (
          SELECT
            i
          FROM
            [fh-bigquery:public_dump.numbers_255]
          WHERE
            (i < 60)
        ) AS b
        WHERE
          (country = 'Egypt' AND date+i*86400000000 = PARSE_UTC_USEC('2011-01-27'))
      ) AS a
      ON
        a.i = b.i
      WHERE
        (a.ending_at != b.ending_at)
      GROUP EACH BY
        ending_at1,
        ending_at2,
        starting_at2,
        a.country,
        b.country
      HAVING
        (c = 60 AND ABS(corr) > 0.254)
      ORDER BY
        corr DESC
      SQL
    end

    subject do
      BB.select(
        'STRFTIME_UTC_USEC(a.ending_at, "%Y-%m-%d") ending_at1',
        'STRFTIME_UTC_USEC(b.ending_at-60*86400000000, "%Y-%m-%d") starting_at2',
        'STRFTIME_UTC_USEC(b.ending_at, "%Y-%m-%d") ending_at2',
        "a.country, b.country, CORR(a.c, b.c) corr",
        "COUNT(*) c"
      ).
        from(
          BB.select("country", "date+i*86400000000 ending_at", "c", "i").
            from("[gdelt-bq:sample_views.country_date_matconf_numarts]", as: "a").
            cross_join(
              BB.select("i").
                from("[fh-bigquery:public_dump.numbers_255]").
                where(i_lt: 60), as: "b"
            ), as: "b"
        ).
        join(
          BB.select("country", "date+i*86400000000 ending_at", "c", "i").
            from("[gdelt-bq:sample_views.country_date_matconf_numarts]", as: "a").
            cross_join(
              BB.select("i").
                from("[fh-bigquery:public_dump.numbers_255]").
                where(i_lt: 60), as: "b"
            ).
            where("country = 'Egypt' AND date+i*86400000000 = PARSE_UTC_USEC('2011-01-27')"), as: "a"
        ).
        on("a.i = b.i").
        where("a.ending_at != b.ending_at").
        group_each("ending_at1", "ending_at2", "starting_at2", "a.country", "b.country").
        having("c = 60 AND ABS(corr) > 0.254").
        order(corr: :desc).
        to_sql
    end

    it { is_expected.to eq sql }
  end
end
