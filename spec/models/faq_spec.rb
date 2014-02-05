# spec/models/faq.rb
require 'spec_helper'
require 'Faq'

describe Faq do
  it "has a valid factory" do
    FactoryGirl.create(:faq).should be_valid
  end
  
  it "is invalid without a group" do
    FactoryGirl.build(:faq, group: nil).should_not be_valid
  end
  
  it "is invalid without a question" do
    FactoryGirl.build(:faq, question: nil).should_not be_valid
  end
  
  it "is invalid without an answer" do
    FactoryGirl.build(:faq, answer: nil).should_not be_valid
  end
  
  it "is invalid without a priority" do
    FactoryGirl.build(:faq, priority: nil).should_not be_valid
  end
  
  it "must be numeric" do
    FactoryGirl.build(:faq, priority: 'abc').should_not be_valid
  end
  
  it "must be be greater than 0" do
    FactoryGirl.build(:faq, priority: 0).should_not be_valid
  end

  it "must be be less than 101" do
    FactoryGirl.build(:faq, priority: 101).should_not be_valid
  end
end