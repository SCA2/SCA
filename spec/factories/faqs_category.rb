require 'faker'

FactoryGirl.define do
  factory :faqs_category do
    category_name { ['Ordering', 'General', 'Support', 'Assembly'].at(rand(0..3)) }
    category_weight { rand(1..100) }
  end
  
  factory :invalid_faqs_category, class: 'FaqsCategory' do
    category_weight nil
  end
end