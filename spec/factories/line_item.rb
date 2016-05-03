# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    association :cart
    association :product
    association :option
    quantity  Random.new.rand(1..10)
  end
end
