# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    association :cart
    association :product
    association :option
    # after(:build) do |line_item|
    #   line_item.cart = build(:cart)
    #   line_item.product = build(:product)
    #   line_item.option = build(:option)
    # end
  end
end
