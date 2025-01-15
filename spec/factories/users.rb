FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 3..25) }
    email { Faker::Internet.email }
    password { "password123" }
  end
end