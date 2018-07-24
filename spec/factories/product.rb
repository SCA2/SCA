require 'faker'

FactoryBot.define do
  factory :product do
    association :product_category
    model {['A12', 'C84', 'J99', 'N72', 'T15', 'D11', 'B16', 'CH02', 'PC01'].at(rand(0..8))}
    sequence(:sort_order)  { |n| "#{(n % 100) + 1}" }
    short_description { Faker::Lorem.sentence.to_s }
    long_description { Faker::Lorem.sentences.to_s }
    image_1 { Faker::Internet.url }
    image_2 { Faker::Internet.url }
    notes { Faker::Lorem.sentence.to_s }
    bom { Faker::Internet.url }
    schematic { Faker::Internet.url }
    assembly { Faker::Internet.url }
    specifications { Faker::Internet.url }
    partial_stock 0
    kit_stock 0

    trait :constant_urls do
      image_1 'A12/A12R17/images/A12-1-M.jpg'
      image_2 'A12/A12R17/images/A12-SP-M.jpg'
      bom 'A12/A12R17/docs/a12_bom.pdf'
      schematic 'A12/A12R17/docs/a12_sch.pdf'
      assembly 'A12/A12R17/docs/a12_asmbly.pdf'
      specifications 'A12/A12R17/docs/a12_asmbly.pdf'
    end

    trait :constant_descriptions do
      short_description 'short description'
      long_description 'long description'
      notes 'notes'
    end

    trait :a12 do
      model 'A12'
      sort_order 10
    end

    trait :c84 do
      model 'C84'
      sort_order 20
    end

    trait :j99 do
      model 'J99'
      sort_order 30
    end

    trait :n72 do
      model 'N72'
      sort_order 40
    end

    factory :a12, traits: [:a12, :constant_descriptions, :constant_urls]
    factory :c84, traits: [:c84, :constant_descriptions, :constant_urls]
    factory :j99, traits: [:j99, :constant_descriptions, :constant_urls]
    factory :n72, traits: [:n72, :constant_descriptions, :constant_urls]
  end
end
