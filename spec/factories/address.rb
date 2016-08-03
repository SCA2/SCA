# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :address do
    association :addressable, factory: :user
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    address_1 Faker::Address.street_address
    address_2 Faker::Address.building_number
    city Faker::Address.city
    state_code Faker::Address.state_abbr
    post_code Faker::Address.zip_code
    country "USA"
    telephone Faker::PhoneNumber.phone_number
    address_type "billing"
  
    trait :constant_name do
      first_name 'Joe'
      last_name 'Tester'
    end

    trait :constant_address_US do
      address_1 '123 Main Street'
      address_2 'Suite B'
      city 'Oakland'
      state_code 'CA'
      post_code '94612'
      country "USA"
      telephone '555-555-5555'
    end

    trait :constant_address_AU do
      address_1 '99 Jellybean Street'
      address_2 'Apt 1'
      city 'Broadview'
      state_code 'SA'
      post_code '5083'
      country 'AU'
      telephone '555-555-5555'
    end

    trait :random_name do
      first_name Faker::Name.first_name
      last_name Faker::Name.last_name
      address_1 Faker::Address.street_address
      address_2 Faker::Address.building_number
      telephone Faker::PhoneNumber.phone_number
    end

    trait :shipping do
      address_type "shipping"
    end

    trait :billing do
      address_type "billing"
    end

    trait :taxable do
      city 'Oakland'
      state_code 'CA'
      post_code '94612'
      country 'USA'
    end

    trait :untaxable do
      city 'Pittsburgh'
      state_code 'PA'
      post_code '15213'
      country 'USA'
    end

    trait :invalid_zip do
      city 'Pittsburgh'
      state_code 'PA'
      post_code '94601'
      country 'USA'      
    end

    factory :billing,
      traits: [:billing]
    factory :shipping,
      traits: [:shipping]
    factory :billing_taxable,
      traits: [:billing, :taxable]
    factory :shipping_taxable,
      traits: [:shipping, :taxable]
    factory :billing_constant_taxable,
      traits: [:billing, :constant_name, :taxable]
    factory :shipping_constant_taxable,
      traits: [:shipping, :constant_name, :taxable]
    factory :invalid_billing_zip,
      traits: [:billing, :constant_name, :invalid_zip]
    factory :invalid_shipping_zip,
      traits: [:shipping, :constant_name, :invalid_zip]
    factory :shipping_US,
      traits: [:shipping, :constant_name, :constant_address_US]
    factory :shipping_AU,
      traits: [:shipping, :constant_name, :constant_address_AU]
  end
end
