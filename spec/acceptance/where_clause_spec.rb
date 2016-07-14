require "spec_helper"

RSpec.describe "WHERE Clause" do
  describe "One Condition in the WHERE Clause" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        suppliers
      WHERE
        (state = 'California')
      SQL
    end

    subject do
      BB.from(:suppliers).
        where(state: "California").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Two Conditions in the WHERE Clause (AND Condition)" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        customers
      WHERE
        (favorite_website = 'techonthenet.com' AND customer_id > 6000)
      SQL
    end

    subject do
      BB.from(:customers).
        where(favorite_website: "techonthenet.com", customer_id_gt: 6000).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Two Conditions in the WHERE Clause (OR Condition)" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        products
      WHERE
        (product_name = 'Pear' OR product_name = 'Apple')
      SQL
    end

    subject do
      BB.from(:products).
        where("product_name = ? OR product_name = ?", "Pear", "Apple").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Combining AND & OR conditions" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        *
      FROM
        products
      WHERE
        (product_id > 3 AND category_id = 75) OR (product_name = 'Pear')
      SQL
    end

    subject do
      BB.from(:products).
        where(product_id_gt: 3, category_id: 75).or.where(product_name: "Pear").
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Combining AND & OR conditions" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        word
      FROM
        publicdata:samples.shakespeare
      WHERE
        (word CONTAINS 'prais' AND word CONTAINS 'ing') OR (word CONTAINS 'laugh' AND word CONTAINS 'ed')
      SQL
    end

    subject do
      BB.select(:word).
        from("publicdata:samples.shakespeare").
        where("word CONTAINS ? AND word CONTAINS ?", "prais", "ing").
        or.where("word CONTAINS ? AND word CONTAINS ?", "laugh", "ed").
        to_sql
    end

    it { is_expected.to eq sql }
  end
end
