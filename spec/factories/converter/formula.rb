FactoryGirl.define do
  factory :converter_formula, class: BB::Converter::Formula do
    column  { Faker::Lorem.word }
    value   { Faker::Lorem.word }
    options { Hash.new }

    trait :between do
      value { build(:converter_value, :range) }
    end

    trait :contains do
      column do
        base     = Faker::Lorem.word
        operator = [:cont, :contains, :like].sample

        [base, operator].join("_")
      end
      value { build(:converter_value, :string) }
    end

    trait :equals do
      column do
        base     = Faker::Lorem.word
        operator = [:eq, :eql, :equals].sample

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric string time).sample) }
    end

    trait :gt do
      column do
        base     = Faker::Lorem.word
        operator = :gt

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric time).sample) }
    end

    trait :gteq do
      column do
        base     = Faker::Lorem.word
        operator = :gteq

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric time).sample) }
    end

    trait :in do
      value { build(:converter_value, %i(array subquery).sample) }
    end

    trait :is do
      value { build(:converter_value, %i(boolean null).sample) }
    end

    trait :lt do
      column do
        base     = Faker::Lorem.word
        operator = :lt

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric time).sample) }
    end

    trait :lteq do
      column do
        base     = Faker::Lorem.word
        operator = :lteq

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric time).sample) }
    end

    trait :match do
      value { build(:converter_value, :regexp) }
    end

    trait :not_between do
      value   { build(:converter_value, :range) }
      options { { negation: true } }
    end

    trait :not_contains do
      column do
        base     = Faker::Lorem.word
        operator = [:not_cont, :not_contains, :not_like].sample

        [base, operator].join("_")
      end
      value { build(:converter_value, :string) }
    end

    trait :not_equals do
      column do
        base     = Faker::Lorem.word
        operator = [:not_eq, :not_eql, :not_equals].sample

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric string time).sample) }
    end

    trait :not_gt do
      column do
        base     = Faker::Lorem.word
        operator = :not_gt

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric time).sample) }
    end

    trait :not_gteq do
      column do
        base     = Faker::Lorem.word
        operator = :not_gteq

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric time).sample) }
    end

    trait :not_in do
      value   { build(:converter_value, %i(array subquery).sample) }
      options { { negation: true } }
    end

    trait :not_is do
      value   { build(:converter_value, %i(boolean null).sample) }
      options { { negation: true } }
    end

    trait :not_lt do
      column do
        base     = Faker::Lorem.word
        operator = :not_lt

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric time).sample) }
    end

    trait :not_lteq do
      column do
        base     = Faker::Lorem.word
        operator = :not_lteq

        [base, operator].join("_")
      end
      value { build(:converter_value, %i(date numeric time).sample) }
    end

    trait :not_match do
      value   { build(:converter_value, :regexp) }
      options { { negation: true } }
    end

    initialize_with { new(column, value, options) }
  end
end
