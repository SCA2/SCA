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
  it { should respond_to(:quantity) }
    
  it { should respond_to(:model) }
  it { should respond_to(:category) }
  it { should respond_to(:description) }
  it { should respond_to(:price) }
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

  describe 'product and option calculations' do
    let(:price)     { 100 } # price in dollars
    let(:quantity)  { 3 }
    let(:weight)    { 2 }
    let(:product)   { build_stubbed(:product) }
    let(:option) { build_stubbed(:option,
      price: price,
      shipping_weight: weight,
      product: product)
    }
    let(:line_item) { build_stubbed(:line_item,
      product: product,
      option: option,
      quantity: quantity)
    }

    it 'returns the option price' do
      expect(line_item.price).to eql option.price_in_cents
    end

    it 'calculates extended_price' do
      expect(line_item.extended_price).to eql option.price_in_cents * quantity
    end
    
    it 'calculates extended_weight' do
      expect(line_item.extended_weight).to eql option.shipping_weight * quantity
    end
  end

end