require 'faker'

FactoryGirl.define do
  factory :order do
    association :cart
    sequence(:email) { |n| "buyer_#{n}@test.com" }
    express_token 'express_token_1234'
    express_payer_id 'express_payer_id_1234'
    ip_address Faker::Internet.ip_v4_address
    shipping_method "UPS Ground"
    shipping_cost Faker::Commerce.price
    sales_tax { cart.subtotal * 0.095 }
    use_billing true

    trait :sales_buyer do
      email 'sales-buyer@seventhcircleaudio.com'
      card_type 'visa'
      card_expires_on '12/2019'
    end

    trait :express_buyer do
      email 'express_buyer@seventhcircleaudio.com'
      card_type 'discover'
      card_expires_on '01/2020'
    end

    trait :constant_shipping do
      shipping_method 'UPS Ground'
      shipping_cost 1500
    end

    factory :paypal_order, traits: [:sales_buyer, :constant_shipping]
    factory :express_order, traits: [:express_buyer, :constant_shipping]
  end
end

