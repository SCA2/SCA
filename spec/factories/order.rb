require 'faker'

FactoryGirl.define do
  factory :order, class: 'Order' do
    email { Faker::Internet.email }
    card_type { Faker::Business.credit_card_type }
    card_expires_on { Faker::Business.credit_card_expiry_date }
    express_token { Faker::Number.number(10) }
    express_payer_id { Faker::Number.number(10) }
    shipping_method { ['UPS Ground', 'UPS 3 Day', 'UPS 2 Day', 'USPS Priority Mail'].at(rand(0..3)) }
    shipping_cost { rand(100..2500) / 100.0 } #Faker::Commerce.price }
    sales_tax { rand(100..1500) / 100.0 } #Faker::Commerce.price }
  end
end
