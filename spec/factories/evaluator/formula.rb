FactoryGirl.define do
  factory :evaluator_formula, class: BB::Evaluator::Formula do
    value   { nil }
    options { Hash.new }

    trait :between do
      value { build(:converter_value, :range) }
    end

    trait :contains do
      value   { build(:converter_value, :string) }
      options { { operator: :contains } }
    end

    trait :not_contains do
      value   { build(:converter_value, :string) }
      options { { operator: :not_contains } }
    end

    trait :equals do
      value   { build(:converter_value, %i(date numeric string time).sample) }
      options { { operator: [nil, :equals].sample } }
    end

    trait :not_equals do
      value   { build(:converter_value, %i(date numeric string time).sample) }
      options { { operator: :not_equals } }
    end

    trait :gt do
      value   { build(:converter_value, %i(date numeric time).sample) }
      options { { operator: :gt } }
    end

    trait :not_gt do
      value   { build(:converter_value, %i(date numeric time).sample) }
      options { { operator: :not_gt } }
    end

    trait :gteq do
      value   { build(:converter_value, %i(date numeric time).sample) }
      options { { operator: :gteq } }
    end

    trait :not_gteq do
      value   { build(:converter_value, %i(date numeric time).sample) }
      options { { operator: :not_gteq } }
    end

    trait :in do
      value { build(:converter_value, %i(array subquery).sample) }
    end

    trait :is do
      value { build(:converter_value, %i(boolean null).sample) }
    end

    trait :lt do
      value   { build(:converter_value, %i(date numeric time).sample) }
      options { { operator: :lt } }
    end

    trait :not_lt do
      value   { build(:converter_value, %i(date numeric time).sample) }
      options { { operator: :not_lt } }
    end

    trait :lteq do
      value   { build(:converter_value, %i(date numeric time).sample) }
      options { { operator: :lteq } }
    end

    trait :not_lteq do
      value   { build(:converter_value, %i(date numeric time).sample) }
      options { { operator: :not_lteq } }
    end

    trait :match do
      value { build(:converter_value, :regexp) }
    end

    initialize_with { new(value, options) }
  end
end
