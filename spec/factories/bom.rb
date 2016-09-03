FactoryGirl.define do
  factory :bom do
    association :option
    sequence(:revision) {|n| "#{n}"}
  end
end