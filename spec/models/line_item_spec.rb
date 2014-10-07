require 'spec_helper'

describe LineItem do

  # let(:product) { FactoryGirl.create(:product) }
  before do
    @line_item = build(:line_item)
  end
  
  subject { @line_item }
  
  it { should respond_to(:product_id) }
  it { should respond_to(:option_id) }
  it { should respond_to(:cart_id) }
  
  its(:product) { should eq product }
  its(:option) { should eq option }
  its(:cart) { should eq cart }
  
  it { should be_valid }
  
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