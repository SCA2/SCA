require 'faker'

FactoryBot.define do
  factory :size_weight_price_tag do
    association :component
    upc { Faker::Number.number(12) }
    full_price {[79, 99, 149, 199, 249, 329, 269, 289, 349, 479, 499].at(rand(0..10))}
    discount_price { full_price - 20 }
    shipping_length { [6, 12, 24].at(rand(0..2)) }
    shipping_width { [4, 9, 12].at(rand(0..2)) }
    shipping_height { [3, 6].at(rand(0..1)) }
    shipping_weight { rand(2..12) }

    trait :constant do
      upc 123456789123
      full_price 329
      discount_price { full_price - 20 }
      shipping_length 12
      shipping_width 9
      shipping_height 6
      shipping_weight 3
    end

    trait :n72 do
      upc 123123123123
      full_price 329
      discount_price { full_price - 20 }
      shipping_length 9
      shipping_width 2
      shipping_height 3
      shipping_weight 3
    end

    factory :constant_tag, traits: [:constant]
    factory :n72_tag, traits: [:n72]

  end
end
