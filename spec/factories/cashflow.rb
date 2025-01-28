FactoryBot.define do
  factory :cashflow do
    association :user
    amount { Faker::Commerce.price(range: -1000.0..1000.0, as_string: false).round(2) }
    description { Faker::Lorem.sentence(word_count: 4) }
    date { Faker::Date.between(from: 2.years.ago, to: Date.today) }
    deleted_at { nil }

    trait :invalid_zero_amount do
      amount { 0 }
    end

    trait :invalid_no_description do
      description { nil }
    end

    trait :invalid_long_description do
      description { "a" * 201 }
    end

    trait :invalid_long_type_name do
      type_name { "a" * 51 }
    end

    trait :invalid_no_date do
      date { nil }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
