require 'faker'

FactoryGirl.define do
  factory :feature, class: 'Feature' do
    association :product
    model {['A12', 'C84', 'J99', 'N72', 'T15', 'D11', 'B16', 'CH02', 'PC01'].at(rand(0..8))}
    caption "Feature Caption"
    sort_order { rand(1..100) }
    description { Faker::Lorem.sentence.to_s }
  end
end
