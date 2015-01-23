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
    component_stock { rand (0..250) }
  end
end
