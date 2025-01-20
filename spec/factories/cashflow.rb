FactoryBot.define do
  factory :cashflow do
    association :user
    amount { Faker::Commerce.price(range: -1000.0..1000.0, as_string: false).round(2) }
    description { Faker::Lorem.sentence(word_count: 4) }
    date { Faker::Date.between(from: 2.years.ago, to: Date.today) }
  end
end
