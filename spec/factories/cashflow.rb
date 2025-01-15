FactoryBot.define do
  factory :cashflow do
    amount { 9.99 }
    description { "MyString" }
    user { association :user }
  end
end
