require 'rails_helper'

describe Option do

  let(:product)   { create(:product) }
  let(:component) { create(:component) }
  let(:option)    { build(:option, product: product, component: component) }
  
  subject { option }
  
  it { should be_valid }
  
  it { should respond_to(:product) }
  it { should respond_to(:component) }
  it { should respond_to(:sort_order) }
  it { should respond_to(:active?) }

  it { should respond_to(:model) }
  it { should respond_to(:description) }
  it { should respond_to(:full_price) }
  it { should respond_to(:full_price_in_cents) }
  it { should respond_to(:discount_price) }
  it { should respond_to(:discount_price_in_cents) }
  it { should respond_to(:shipping_length) }
  it { should respond_to(:shipping_width) }
  it { should respond_to(:shipping_height) }
  it { should respond_to(:shipping_weight) }

  it { expect(option.product).to eql product }

  it 'reports its active status' do
    option.active = false
    expect(option.active?).to be false
    option.active = true
    expect(option.active?).to be true
  end

  describe 'product associations' do
    it 'is destroyed with associated product' do
      product = create(:product)
      create(:option, product: product)
      expect { product.destroy }.to change { Option.count }.by(-1)
    end
    
    it 'does not destroy associated product when destroyed' do
      product = create(:product)
      option = create(:option, product: product)
      expect { option.destroy }.not_to change { Product.count }
    end
  end

  describe 'component associations' do
    it 'restricts associated component destroy' do
      component = create(:component)
      create(:option, component: component)
      expect { component.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
    
    it 'does not destroy associated component when destroyed' do
      component = create(:component)
      option = create(:option, component: component)
      expect { option.destroy }.not_to change { Component.count }
    end
  end

  describe 'stock messages' do
    let(:op) { build(:option) }
    it 'reports correct message for disabled?' do
      allow(op).to receive(:disabled?)  { true }
      expect(op.stock_message).to eq('Not available at this time')
    end

    it 'reports correct message for stock > cutoff' do
      allow(op).to receive(:disabled?)  { false }
      allow(op.component).to receive(:stock)  { Option::STOCK_CUTOFF + 1 }
      allow(op.component).to receive(:lead_time)  { 0 }
      expect(op.stock_message).to eq('Can ship today')
    end

    it 'reports correct message for stock > 0' do
      allow(op).to receive(:disabled?)  { false }
      allow(op.component).to receive(:stock)  { 1 }
      allow(op.component).to receive(:lead_time)  { 0 }
      expect(op.stock_message).to eq('1 can ship today')
    end

    it 'reports correct message for stock <= 0 and lead_time <= cutoff' do
      allow(op).to receive(:disabled?)  { false }
      allow(op.component).to receive(:stock)  { 0 }
      allow(op.component).to receive(:lead_time)  { 3 }
      expect(op.stock_message).to eq("Can ship in 3 days")
    end

    it 'reports correct message for stock <= 0 and lead_time <= cutoff' do
      allow(op).to receive(:disabled?)  { false }
      allow(op.component).to receive(:stock)  { 0 }
      allow(op.component).to receive(:lead_time)  { 1 }
      expect(op.stock_message).to eq("Can ship in 1 day")
    end

    it 'reports correct message for stock <= 0 and lead_time > cutoff' do
      allow(op).to receive(:disabled?)  { false }
      allow(op.component).to receive(:stock)  { 0 }
      allow(op.component).to receive(:lead_time)  { Option::LEAD_TIME_CUTOFF + 1 }
      expect(op.stock_message).to include('for lead time')
    end
  end
end
