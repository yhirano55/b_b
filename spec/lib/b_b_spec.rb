require "spec_helper"

describe BB do
  describe ".build" do
    let(:result) do
      format_sql <<-SQL
      SELECT
        id,
        name,
        country_id,
        countries.song AS song
      FROM
        member AS member
      JOIN
        countries AS countries
      ON
        member.country_id = countries.id
      ORDER BY
        id DESC
      LIMIT
        300 OFFSET 100
      SQL
    end

    subject do
      BB.build do |rel|
        rel.select :id, :name, :country_id, "countries.song AS song"
        rel.from :member, as: :member
        rel.join :countries, as: :countries
        rel.on "member.country_id = countries.id"
        rel.order id: :desc
        rel.limit 300
        rel.offset 100
      end
    end

    it { is_expected.to eq result }
  end

  describe ".method_missing" do
    BB::API.values.flatten.each do |method_name|
      context "Relation##{method_name}" do
        subject { described_class.public_send(method_name, *args) }

        context "when args are empty" do
          let(:args) { [] }

          it { expect { subject }.to raise_error(BB::ArgumentError, "wrong number of arguments ##{method_name} (at least 1)") }
        end

        context "when args are not empty" do
          let(:args) { %w(123) }

          it { is_expected.to be_an_instance_of(BB::Relation) }
        end
      end
    end

    %i(and or not).each do |method_name|
      context "Relation##{method_name}" do
        subject { described_class.public_send(method_name) }

        it { is_expected.to be_an_instance_of(BB::Relation) }
      end
    end
  end
end
