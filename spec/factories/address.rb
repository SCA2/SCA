# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :user_address, class: "Address" do
    association :addressable, :factory => :user
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    address_1 Faker::Address.street_address
    address_2 Faker::Address.building_number
    city Faker::Address.city
    state_code Faker::Address.state_abbr
    post_code Faker::Address.zip_code
    country "USA"
    telephone Faker::PhoneNumber.phone_number
  end
  
  factory :order_address, class: "Address" do
    association :addressable, :factory => :order
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    address_1 Faker::Address.street_address
    address_2 Faker::Address.building_number
    city Faker::Address.city
    state_code Faker::Address.state_abbr
    post_code Faker::Address.zip_code
    country "USA"
    telephone Faker::PhoneNumber.phone_number
  end
end
