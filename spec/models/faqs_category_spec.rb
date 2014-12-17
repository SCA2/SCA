require 'rails_helper'

describe FaqsCategory do

  it "has a valid factory" do
    faqs_category = create(:faqs_category)
    expect(faqs_category).to be_valid
  end
  
  it "is invalid without a category_name" do
    faqs_category = build(:faqs_category, category_name: nil)
    expect(faqs_category).not_to be_valid
  end
  
  it "is invalid without a category_weight" do
    faqs_category = build(:faqs_category, category_weight: nil)
    expect(faqs_category).not_to be_valid
  end
  
  it "is invalid with a duplicate category_name" do
    faqs_category1 = create(:faqs_category, category_name: 'first')
    faqs_category2 = build(:faqs_category, category_name: 'first')
    expect(faqs_category2).not_to be_valid
  end
  
  it "is invalid with a duplicate category_weight" do
    faqs_category1 = create(:faqs_category, category_weight: 10)
    faqs_category2 = build(:faqs_category, category_weight: 10)
    expect(faqs_category2).not_to be_valid
  end
  
  it "category_weight must be numeric" do
    faqs_category = build(:faqs_category, category_weight: 'abc')
    expect(faqs_category).not_to be_valid
  end
  
  it "category_weight must be be greater than 0" do
    faqs_category = build(:faqs_category, category_weight: 0)
    expect(faqs_category).not_to be_valid
  end

  it "category_weight must be be less than 101" do
    faqs_category = build(:faqs_category, category_weight: 101)
    expect(faqs_category).not_to be_valid
  end
  
  it "returns an array sorted by category_weight" do
    create(:faqs_category, category_weight: 1, category_name: 'abc')
    create(:faqs_category, category_weight: 2, category_name: 'def')
    create(:faqs_category, category_weight: 3, category_name: 'ghi')
    expect(FaqsCategory.order(:category_weight).first.category_name).to eq 'abc'
  end

  it "returns an array sorted by category_weight" do
    create(:faqs_category, category_weight: 1, category_name: 'abc')
    create(:faqs_category, category_weight: 2, category_name: 'def')
    create(:faqs_category, category_weight: 3, category_name: 'ghi')
    expect(FaqsCategory.order(:category_weight).first.category_name).not_to eq 'def'
  end
end