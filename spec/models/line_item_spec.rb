require 'rails_helper'

describe LineItem do

  before do
    @line_item = FactoryGirl.build_stubbed(:line_item)
  end

  it "has a valid factory" do
    expect(@line_item).to be_valid
  end

  subject { @line_item }
  
  it { should be_valid }

  it { should respond_to(:product) }
  it { should respond_to(:option) }
  it { should respond_to(:cart) }
    
  it { should respond_to(:product_model) }
  it { should respond_to(:option_model) }
  it { should respond_to(:full_model) }
  it { should respond_to(:extended_price) }
  it { should respond_to(:extended_weight) }
  
  # its(:product) { should eq product }
  # its(:option) { should eq option }
  # its(:cart) { should eq cart }

  describe 'when product_id is not present' do
    before { @line_item.product_id = nil }
    it { should_not be_valid }
  end
  
  describe 'when option_id is not present' do
    before { @line_item.option_id = nil }
    it { should_not be_valid }
  end

  describe 'when cart_id is not present' do
    before { @line_item.cart_id = nil }
    it { should_not be_valid }
  end
end