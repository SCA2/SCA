require 'faker'

FactoryGirl.define do
  factory :product, class: 'Product' do
    model {['A12', 'C84', 'J99', 'N72', 'T15', 'D11', 'B16', 'CH02', 'PC01'].at(rand(0..8))}
    short_description { Faker::Lorem.sentence.to_s }
    long_description { Faker::Lorem.sentences.to_s }
    image_1 { Faker::Internet.url }
    image_2 { Faker::Internet.url }
    category {['Microphone Preamp', 'DI', 'Compressor', 'Discrete Op-Amp', 'Chassis'].at(rand(0..4))}
    category_sort_order { rand(1..100) }
    model_sort_order { rand(1..100) }
    notes { Faker::Lorem.sentence.to_s }
    bom { Faker::Internet.url }
    schematic { Faker::Internet.url }
    assembly { Faker::Internet.url }
    current_option { rand(1..100) }
    specifications { Faker::Internet.url }
  end

  factory :feature, class: 'Feature' do
    product
    model {['A12', 'C84', 'J99', 'N72', 'T15', 'D11', 'B16', 'CH02', 'PC01'].at(rand(0..8))}
    caption "Feature Caption"
    sort_order { rand(1..100) }
    description { Faker::Lorem.sentence.to_s }
  end

  factory :option, class: 'Option' do
    model {['A12', 'C84', 'J99', 'N72', 'T15', 'D11', 'B16', 'CH02', 'PC01'].at(rand(0..8))}
    description { Faker::Lorem.sentence.to_s }
    price {[79, 99, 149, 199, 249, 329, 269, 289, 349, 479, 499].at(rand(0..10))}
    upc { Faker::Number.number(12) }
    shipping_weight { rand(2..12) }
    kit_stock { rand (0..250) }
    part_stock { rand (0..250) }
    sort_order { (1..100) }
    discount { price - 20 }
    shipping_length { [6, 12, 24].at(rand(0..2)) }
    shipping_width { [4, 9, 12].at(rand(0..2)) }
    shipping_height { [3, 6].at(rand(0..1)) }
    assembled_stock { rand(0..250) }
    partial_stock { rand(0..250) }
    end
end
