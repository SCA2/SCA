# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    quantity { 1 }
    extended_price { 1 }
    remove { false }
    cart
    product
    option

    after(:create) do |line_item|
        line_item.cart = FactoryGirl.create(:cart)
        line_item.product = FactoryGirl.create(:product)
        line_item.option = FactoryGirl.create(:option)
    end
  end
end
