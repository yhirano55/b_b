FactoryGirl.define do
  factory :converter_table, class: BB::Converter::Table do
    value   { Faker::Lorem.word }
    options { Hash.new }

    trait :plain do
      value { Faker::Lorem.word }
    end

    trait :subquery do
      value { build(:converter_value, :subquery).value }
    end

    trait :table_date_range do
      options do
        {
          from: Date.new(2017, 1, 1),
          to:   Date.new(2017, 2, 1)
        }
      end
    end

    trait :table_date do
      options do
        {
          on: Date.new(2017, 1, 1)
        }
      end
    end

    initialize_with { new(value, options) }
  end
end
