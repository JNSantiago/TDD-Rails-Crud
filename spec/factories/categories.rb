FactoryBot.define do
  factory :category do
    name Faker::Food.fruits

    transient do
      qtt_products 3
    end

    trait :with_products do
      after(:create) do |category, evaluator|
        create_list(:product, evaluator.qtt_products, category: category)
      end
    end

    factory :category_with_products, traits: [:with_products]
  end
end
