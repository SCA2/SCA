require 'faker'

FactoryBot.define do
  factory :faqs_category do
    sequence(:category_name) {|n| "Category-#{n}" }
    sequence(:category_weight) {|n| "#{(n % 100) + 1}" }
  end
  
  factory :invalid_faqs_category, class: 'FaqsCategory' do
    category_weight nil
  end
end