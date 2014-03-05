# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_option, :class => 'ProductOptions' do
    model "MyString"
    description "MyString"
    price 1
    upc "MyString"
    shipping_weight 1
    finished_stock 1
    kit_stock 1
    part_stock 1
    option_sort_order 1
  end
end
