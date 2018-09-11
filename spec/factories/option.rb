require 'faker'

FactoryBot.define do
  factory :option do
    association :product
    association :component
    sequence(:sort_order)  { |n| "#{(n % 100) + 1}" }
    active { true }
  end
end
