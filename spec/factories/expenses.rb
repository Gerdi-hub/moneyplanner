FactoryBot.define do
  factory :expense do
    amount { "9.99" }
    description { "MyString" }
    user { nil }
  end
end
