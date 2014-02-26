# spec/factories/product.rb

require 'faker'

FactoryGirl.define do
  factory :product, class: 'Product' do
    category {['Microphone Preamp', 'DI', 'Compressor', 'Discrete Op-Amp', 'Chassis'].at(rand(0..4))}
    category_weight { rand(1..100) }
    model {['A12', 'C84', 'J99', 'N72', 'T15', 'D11', 'B16', 'CH02', 'PC01'].at(rand(0..8))}
    model_weight { rand(1..100) }
    short_description { Faker::Lorem.sentence.to_s }
    long_description { Faker::Lorem.sentences.to_s }
    notes { Faker::Lorem.sentence.to_s }
    upc { Faker::Number.number(12) }
    image_1 { Faker::Internet.url }
    image_2 { Faker::Internet.url }
    price { Faker::Number.number(3) } 
  end

  factory :feature, class: 'Feature' do
    product
    model {['A12', 'C84', 'J99', 'N72', 'T15', 'D11', 'B16', 'CH02', 'PC01'].at(rand(0..8))}
    caption "Feature Caption"
    sort_order { rand(1..100) }
    description { Faker::Lorem.sentence.to_s }
  end
end
