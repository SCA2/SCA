# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    cart_id 1
    first_name "MyString"
    last_name "MyString"
    shipping_address_1 "MyString"
    shipping_address_2 "MyString"
    shipping_city "MyString"
    shipping_state "MyString"
    shipping_post_code "MyString"
    shipping_country "MyString"
    email "MyString"
    telephone "MyString"
    card_type "MyString"
    card_expires_on "2014-03-19"
    cart_id 1
  end
end
