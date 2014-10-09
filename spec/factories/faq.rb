# spec/factories/faqs.rb
require 'faker'

FactoryGirl.define do
  factory :faq, class: 'Faq' do
    category {['Ordering', 'General', 'Support', 'Assembly'].at(rand(0..3))}
    category_weight {rand(1..100)}
    question {Faker::Lorem.sentence.to_s}
    question_weight {rand(1..100)}
    answer {Faker::Lorem.sentences.to_s}
  end
  
  factory :invalid_faq, class: 'Faq' do
    category 'Poo'
    category_weight nil
  end
end