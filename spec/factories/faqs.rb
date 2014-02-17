# spec/factories/faqs.rb
require 'faker'

FactoryGirl.define do
  factory :faq, class: 'Faq' do
    group {['Ordering', 'General', 'Support', 'Assembly'].at(rand(0..3))}
    question {Faker::Lorem.sentence.to_s}
    answer {Faker::Lorem.sentences.to_s}
    priority {rand(1..100)}
  end
  
  factory :invalid_faq, class: 'Faq' do
    group 'Poo'
  end
end