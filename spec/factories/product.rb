require 'faker'

FactoryGirl.define do
  factory :product do
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
end
