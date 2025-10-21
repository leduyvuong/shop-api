# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    association :category
    name { Faker::Commerce.product_name }
    slug { Faker::Internet.unique.slug }
    price { Faker::Commerce.price(range: 10.0..200.0) }
    stock { rand(1..50) }
    status { :active }
    sku { Faker::Code.unique.asin }
  end
end
