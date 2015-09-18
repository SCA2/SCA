require 'faker'

FactoryGirl.define do
  factory :order do
    email Faker::Internet.email
  end
end

