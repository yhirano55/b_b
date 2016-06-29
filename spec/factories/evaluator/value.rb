FactoryGirl.define do
  factory :evaluator_value, class: BB::Evaluator::Value do
    value   { Integer Faker::Number.number(3) }
    options { Hash.new }

    trait :array do
      value { Faker::Lorem.words }
    end

    trait :boolean do
      value { Faker::Boolean.boolean }
    end

    trait :date do
      value { Faker::Date.backward(30) }
    end

    trait :null do
      value { nil }
    end

    trait :numeric do
      value { Integer Faker::Number.number(5) }
    end

    trait :range do
      value { 0...100 }
    end

    trait :regexp do
      value { Regexp.new(Faker::Lorem.word) }
    end

    trait :string do
      value { [Faker::Lorem.word, Faker::Lorem.word.to_sym].sample }
    end

    trait :subquery do
      value { BB.from(Faker::Lorem.word) }
    end

    trait :time do
      value { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    end

    initialize_with do
      new(value, options)
    end
  end
end
