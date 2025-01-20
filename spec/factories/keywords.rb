FactoryBot.define do
  factory :keyword do
    name { Faker::Lorem.unique.word[0..29] }
    type_name { Faker::Lorem.word[0..29] }
  end
end
