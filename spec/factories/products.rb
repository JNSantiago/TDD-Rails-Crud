FactoryBot.define do
  factory :product do
    name Faker::Food.dish
    description Faker::Food.description
    price 1.5
    category
  end
end
