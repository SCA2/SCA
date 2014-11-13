# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :user_address, class: "Address" do
    association :addressable, :factory => :user
    first_name "MyString"
    last_name "MyString"
    address_1 "MyString"
    address_2 "MyString"
    city "MyString"
    state "MyString"
    post_code "MyString"
    country "MyString"
    telephone "MyString"
  end
  
  factory :order_address, class: "Address" do
    association :addressable, :factory => :order
    first_name "MyString"
    last_name "MyString"
    address_1 "MyString"
    address_2 "MyString"
    city "MyString"
    state "MyString"
    post_code "MyString"
    country "MyString"
    telephone "MyString"
  end
end
