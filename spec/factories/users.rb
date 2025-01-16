FactoryBot.define do
  factory :user do
    username { "testuser" }
    email { "testuser@example.com" }
    password { "password" }
  end
end