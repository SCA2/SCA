FactoryGirl.define do
  factory :bom do
    association :option
    sequence(:revision) {|n| "#{n}"}
    sequence(:pdf) {|n| "http://www.bom_#{n}.pdf"}
  end
end