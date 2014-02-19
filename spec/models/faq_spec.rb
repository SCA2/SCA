# spec/models/faq.rb
require 'spec_helper'
require 'Faq'

describe Faq do
  it "has a valid factory" do
    faq = create(:faq)
    expect(faq).to be_valid
  end
  
  it "is invalid without a group" do
    faq = build(:faq, category: nil)
    expect(faq).not_to be_valid
  end
  
  it "is invalid without a valid group" do
    faq = build(:faq, category: 'abc')
    expect(faq).not_to be_valid
  end
  
  it "is invalid without a question" do
    faq = build(:faq, question: nil)
    expect(faq).not_to be_valid
  end
  
  it "is invalid with a duplicate question in a group" do
    faq1 = create(:faq, category: 'general', question: 'abc')
    faq2 = build(:faq, category: 'general', question: 'abc')
    expect(faq2).not_to be_valid
  end
  
  it "is valid with a duplicate question in a different group" do
    faq1 = create(:faq, category: 'general', question: 'abc')
    faq2 = build(:faq, category: 'order', question: 'abc')
    expect(faq2).to be_valid
  end
  
  it "is invalid without an answer" do
    faq = build(:faq, answer: nil)
    expect(faq).not_to be_valid
  end
  
  it "is invalid without a priority" do
    faq = build(:faq, question_weight: nil)
    expect(faq).not_to be_valid
  end
  
  it "must be numeric" do
    faq = build(:faq, question_weight: 'abc')
    expect(faq).not_to be_valid
  end
  
  it "must be be greater than 0" do
    faq = build(:faq, question_weight: 0)
    expect(faq).not_to be_valid
  end

  it "must be be less than 101" do
    faq = build(:faq, question_weight: 101)
    expect(faq).not_to be_valid
  end
  
  it "returns an array sorted by group and priority" do
    create(:faq, category: 'general', question_weight: 1, question: 'abc')
    create(:faq, category: 'general', question_weight: 2)
    create(:faq, category: 'order', question_weight: 1, question: 'def')
    create(:faq, category: 'order', question_weight: 2)
    expect(Faq.order(:question_weight, :group).first.question).to eq 'abc'
  end

  it "returns an array sorted by group and priority" do
    create(:faq, category: 'general', question_weight: 1, question: 'abc')
    create(:faq, category: 'general', question_weight: 2)
    create(:faq, category: 'order', question_weight: 1, question: 'def')
    create(:faq, category: 'order', question_weight: 2)
    expect(Faq.order(:question_weight, :group).first.question).not_to eq 'def'
  end
end