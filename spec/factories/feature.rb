require 'faker'

FactoryBot.define do
  factory :feature do
    association :product
    caption { "Caption: " + Faker::Lorem.sentence.to_s }
    sequence(:sort_order)  { |n| "#{(n % 100) + 1}" }
    description { "Description: " + Faker::Lorem.sentence.to_s }
  end
end
