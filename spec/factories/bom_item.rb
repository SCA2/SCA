FactoryGirl.define do
  factory :bom_item do
    association :bom
    association :component
    quantity 1
    sequence(:reference ) {|n| "R#{n}"}
  end
end