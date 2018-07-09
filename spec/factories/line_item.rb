# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :line_item do
    association :cart
    association :product
    association :option
    quantity  1
  end
end
