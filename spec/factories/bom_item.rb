FactoryGirl.define do
  factory :bom_item do
    association :bom
    association :component
    sequence(:reference ) {|n| "R#{n}"}
  end
end