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
    sequence(:model_sort_order)  { |n| "#{n}" }
    notes { Faker::Lorem.sentence.to_s }
    bom { Faker::Internet.url }
    schematic { Faker::Internet.url }
    assembly { Faker::Internet.url }
    specifications { Faker::Internet.url }

    trait :constant_urls do
      image_1 'url/to/image_1'
      image_2 'url/to/image_2'
      bom 'url/to/bom'
      schematic 'url/to/schematic'
      assembly 'url/to/assembly'
      specifications 'url/to/specifications'
    end

    trait :constant_descriptions do
      short_description 'short description'
      long_description 'long description'
      notes 'notes'
    end

    trait :a12 do
      model 'A12'
      category 'Microphone Preamp'
      category_sort_order 10
      model_sort_order 10
    end

    trait :c84 do
      model 'C84'
      category 'Microphone Preamp'
      category_sort_order 10
      model_sort_order 20
    end

    trait :j99 do
      model 'J99'
      category 'Microphone Preamp'
      category_sort_order 10
      model_sort_order 30
    end

    trait :n72 do
      model 'N72'
      category 'Microphone Preamp'
      category_sort_order 10
      model_sort_order 40
    end

    factory :a12, traits: [:a12, :constant_descriptions, :constant_urls]
    factory :c84, traits: [:c84, :constant_descriptions, :constant_urls]
    factory :j99, traits: [:j99, :constant_descriptions, :constant_urls]
    factory :n72, traits: [:n72, :constant_descriptions, :constant_urls]
  end
end
