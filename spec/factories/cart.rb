# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart do
    purchased_at { Time.now }
    # order
    # line_item
  end
end
