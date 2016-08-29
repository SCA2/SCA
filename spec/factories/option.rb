require 'faker'

FactoryGirl.define do
  factory :option, class: 'Option' do
    model {['KF-2S', 'KF-2L', 'KF-2H', 'KA-2S', 'KA-2L', 'KA-2H', 'KF', 'KA'].at(rand(0..6))}
    description { Faker::Lorem.sentence.to_s }
    price {[79, 99, 149, 199, 249, 329, 269, 289, 349, 479, 499].at(rand(0..10))}
    upc { Faker::Number.number(12) }
    shipping_weight { rand(2..12) }
    sequence(:sort_order)  { |n| "#{n}" }
    discount { price - 20 }
    shipping_length { [6, 12, 24].at(rand(0..2)) }
    shipping_width { [4, 9, 12].at(rand(0..2)) }
    shipping_height { [3, 6].at(rand(0..1)) }
    assembled_stock { rand(0..250) }
    partial_stock { rand(0..250) }
    kit_stock { rand (0..250) }
    active { true }

    trait :ka do
      model 'KA'
      description 'fully assembled'
      price 479
      discount 0
      upc '123456789012'
      sort_order 10
    end

    trait :in_stock do
      assembled_stock 8
      partial_stock 12
      component_stock 100
      active { true }
    end

    trait :module do
      shipping_weight 3
      shipping_length 10
      shipping_width 4
      shipping_height 2
    end

    factory :ka, traits: [:ka, :in_stock, :module]
  end
end
