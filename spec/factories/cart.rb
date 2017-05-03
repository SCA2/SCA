FactoryGirl.define do
  factory :cart do
    purchased_at { nil }
    invoice_token 'random_token'
    invoice_sent_at { nil }
    invoice_retrieved_at { nil }
  end
end