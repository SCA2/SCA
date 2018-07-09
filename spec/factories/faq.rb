require 'faker'

FactoryBot.define do
  factory :faq do
    faqs_category
    question { Faker::Lorem.sentence.to_s }
    question_weight { rand(1..100) }
    answer { Faker::Lorem.sentences.to_s }
  end
  
  factory :invalid_faq, class: 'Faq' do
    answer { nil }
  end
end