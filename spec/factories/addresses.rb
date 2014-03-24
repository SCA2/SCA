# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    order_id 1
    billing_first_name "MyString"
    billing_last_name "MyString"
    billing_address_1 "MyString"
    billing_address_2 "MyString"
    billing_city "MyString"
    billing_state "MyString"
    billing_post_code "MyString"
    billinig_country "MyString"
    billing_telephone "MyString"
    shipping_first_name "MyString"
    shipping_last_name "MyString"
    shipping_address_1 "MyString"
    shipping_address_2 "MyString"
    shipping_city "MyString"
    shipping_state "MyString"
    shipping_post_code "MyString"
    shipping_country "MyString"
    shipping_telephone "MyString"
  end
end
