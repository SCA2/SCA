FactoryBot.define do
  factory :transaction do
    association :order
    action "action"
    amount 123
    success true
    authorization "authorization"
    message "message"
    params "params"
    tracking_number "1ZY7V28300000000"
    shipped_at Date.yesterday
  end
end
