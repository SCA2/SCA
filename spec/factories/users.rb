# spec/factories/users.rb
require 'faker'

FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar42"
    password_confirmation "foobar42"
    
    factory :admin do
      admin true
    end
  end
end
