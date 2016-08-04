FactoryGirl.define do
  factory :bom do
    association :product
    sequence(:revision ) {|n| "rev_#{n}"}
  end
end