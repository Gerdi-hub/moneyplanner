FactoryBot.define do
  factory :income do
    amount { "9.99" }
    description { "MyString" }
    user { nil }
  end
end
