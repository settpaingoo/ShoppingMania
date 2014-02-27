# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    name Faker::Commerce.product_name
    price { rand(5..500) }
    stock { rand(1..10) }
    brand_id 1
    category_id 1
  end
end
