# spec/factories/users.rb
require 'faker'

FactoryGirl.define do
  factory :user do |u|
    u.name "Bob Roll"
    u.email "bob@roll.com"
    u.password "foobar"
    u.password_confirmation "foobar"
  end
end
