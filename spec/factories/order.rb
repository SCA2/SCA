require 'faker'

FactoryGirl.define do
  sequence(:email) { |n| "buyer_#{n}@test.com" }

  factory :order do
    association :cart
    email
    card_type Faker::Business.credit_card_type
    card_expires_on Faker::Business.credit_card_expiry_date
    express_token Faker::Internet.password
    express_payer_id Faker::Internet.password
    shipping_method "UPS Ground"
    shipping_cost Faker::Commerce.price
    use_billing true
    state Faker::Address.state_abbr
  end
end

