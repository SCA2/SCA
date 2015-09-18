require 'rails_helper'

describe Faq do

  let(:category_1) { create(:faqs_category, category_name: 'General', category_weight: 1) }
  let(:category_2) { create(:faqs_category, category_name: 'Ordering', category_weight: 2) }

  it "has a valid factory" do
    faq = create(:faq)
    expect(faq).to be_valid
  end
  
  it "is invalid without a category" do
    faq = build(:faq, faqs_category: nil)
    expect(faq).not_to be_valid
  end
  
  it "is invalid without a question" do
    faq = build(:faq, question: nil)
    expect(faq).not_to be_valid
  end
  
  it "is invalid with a duplicate question in a category" do
    faq1 = create(:faq, faqs_category: category_1, question: 'abc')
    faq2 = build(:faq, faqs_category: category_1, question: 'abc')
    expect(faq2).not_to be_valid
  end
  
  it "is valid with a duplicate question in a different category" do
    faq1 = create(:faq, faqs_category: category_1, question: 'abc')
    faq2 = build(:faq, faqs_category: category_2, question: 'abc')
    expect(faq2).to be_valid
  end
  
  it "is invalid without an answer" do
    faq = build(:faq, answer: nil)
    expect(faq).not_to be_valid
  end
  
  it "is invalid without a question weight" do
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

  it "must be be less than 501" do
    faq = build(:faq, question_weight: 501)
    expect(faq).not_to be_valid
  end
  
  it "is invalid without a category weight" do
    faq = build(:faq, question_weight: nil)
    expect(faq).not_to be_valid
  end
    
  it "returns an array sorted by category_weight and question_weight" do
    create(:faq, faqs_category: category_1, question: 'abc', question_weight: 1)
    create(:faq, faqs_category: category_1, question: 'def', question_weight: 2)
    create(:faq, faqs_category: category_2, question: 'ghi', question_weight: 3)
    create(:faq, faqs_category: category_2, question: 'jkl', question_weight: 4)
    expect(Faq.order(:question_weight, :faqs_category_id).first.question).to eq 'abc'
  end

  it "returns an array sorted by category_weight and question_weight" do
    create(:faq, faqs_category: category_1, question: 'abc', question_weight: 1)
    create(:faq, faqs_category: category_1, question: 'def', question_weight: 2)
    create(:faq, faqs_category: category_2, question: 'ghi', question_weight: 3)
    create(:faq, faqs_category: category_2, question: 'jkl', question_weight: 4)
    expect(Faq.order(:question_weight, :faqs_category_id).first.question).not_to eq 'def'
  end
end