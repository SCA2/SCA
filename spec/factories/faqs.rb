# spec/factories/faqs.rb
require 'faker'

FactoryGirl.define do
  factory :faq do |f|
    f.group {[:order, :general, :support, :assembly].at(rand(0..3)).to_s}
    f.question {Faker::Lorem.sentence.to_s}
    f.answer {Faker::Lorem.sentences.to_s}
    f.priority {rand(1..100)}
  end
end