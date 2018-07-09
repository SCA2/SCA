require 'faker'

FactoryBot.define do
  factory :product_category do
    sequence(:name) {|n| "Category-#{n}" }
    sequence(:sort_order) {|n| "#{(n % 100) + 1}" }
  end
end