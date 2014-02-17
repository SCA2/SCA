# spec/models/faq.rb
require 'spec_helper'
require 'Faq'

describe Faq do
  it "has a valid factory" do
    faq = create(:faq)
    expect(faq).to be_valid
  end
  
  it "is invalid without a group" do
    faq = build(:faq, group: nil)
    expect(faq).not_to be_valid
  end
  
  it "is invalid without a valid group" do
    faq = build(:faq, group: 'abc')
    expect(faq).not_to be_valid
  end
  
  it "is invalid without a question" do
    faq = build(:faq, question: nil)
    expect(faq).not_to be_valid
  end
  
  it "is invalid with a duplicate question in a group" do
    faq1 = create(:faq, group: 'general', question: 'abc')
    faq2 = build(:faq, group: 'general', question: 'abc')
    expect(faq2).not_to be_valid
  end
  
  it "is valid with a duplicate question in a different group" do
    faq1 = create(:faq, group: 'general', question: 'abc')
    faq2 = build(:faq, group: 'order', question: 'abc')
    expect(faq2).to be_valid
  end
  
  it "is invalid without an answer" do
    faq = build(:faq, answer: nil)
    expect(faq).not_to be_valid
  end
  
  it "is invalid without a priority" do
    faq = build(:faq, priority: nil)
    expect(faq).not_to be_valid
  end
  
  it "must be numeric" do
    faq = build(:faq, priority: 'abc')
    expect(faq).not_to be_valid
  end
  
  it "must be be greater than 0" do
    faq = build(:faq, priority: 0)
    expect(faq).not_to be_valid
  end

  it "must be be less than 101" do
    faq = build(:faq, priority: 101)
    expect(faq).not_to be_valid
  end
  
  it "returns an array sorted by group and priority" do
    create(:faq, group: 'general', priority: 1, question: 'abc')
    create(:faq, group: 'general', priority: 2)
    create(:faq, group: 'order', priority: 1, question: 'def')
    create(:faq, group: 'order', priority: 2)
    expect(Faq.order(:priority, :group).first.question).to eq 'abc'
  end

  it "returns an array sorted by group and priority" do
    create(:faq, group: 'general', priority: 1, question: 'abc')
    create(:faq, group: 'general', priority: 2)
    create(:faq, group: 'order', priority: 1, question: 'def')
    create(:faq, group: 'order', priority: 2)
    expect(Faq.order(:priority, :group).first.question).not_to eq 'def'
  end
end