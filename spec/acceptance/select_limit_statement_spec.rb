require "spec_helper"

RSpec.describe "SELECT LIMIT Statement" do
  describe "Using LIMIT keyword" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        contact_id,
        last_name,
        first_name
      FROM
        contacts
      WHERE
        (website = 'TechOnTheNet.com')
      ORDER BY
        contact_id DESC
      LIMIT
        5
      SQL
    end

    subject do
      BB.select(:contact_id, :last_name, :first_name).
        from(:contacts).
        where(website: "TechOnTheNet.com").
        order(contact_id: :desc).
        limit(5).
        to_sql
    end

    it { is_expected.to eq sql }
  end

  describe "Using OFFSET keyword" do
    let(:sql) do
      format_sql <<-SQL
      SELECT
        contact_id,
        last_name,
        first_name
      FROM
        contacts
      WHERE
        (website = 'TechOnTheNet.com')
      ORDER BY
        contact_id DESC
      LIMIT
        5 OFFSET 2
      SQL
    end

    subject do
      BB.select(:contact_id, :last_name, :first_name).
        from(:contacts).
        where(website: "TechOnTheNet.com").
        order(contact_id: :desc).
        limit(5).
        offset(2).
        to_sql
    end

    it { is_expected.to eq sql }
  end
end
