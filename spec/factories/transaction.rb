# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    association :order
    action "action"
    amount 123
    success true
    authorization "authorization"
    message "message"
    params "params"
  end
end
