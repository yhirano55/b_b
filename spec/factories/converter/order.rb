FactoryGirl.define do
  factory :converter_order, class: BB::Converter::Order do
    column  { Faker::Lorem.word }
    options { { sort_key: :asc } }

    %i(asc desc undefined).each do |sort_key|
      trait sort_key do
        options { { sort_key: sort_key } }
      end
    end

    initialize_with { new(column, options) }
  end
end
