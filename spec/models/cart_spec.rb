require 'rails_helper'

describe Cart do

  let(:cart) { build(:cart) }
  
  subject { cart }

  it { should respond_to(:order) }
  it { should respond_to(:line_items) }
  it { should respond_to(:purchased_at) }

  it { should respond_to(:add_item) }
  it { should respond_to(:discount) }
  it { should respond_to(:combo_discount) }
  it { should respond_to(:subtotal) }
  it { should respond_to(:total_volume) }
  it { should respond_to(:min_dimension) }
  it { should respond_to(:max_dimension) }
  it { should respond_to(:total_items) }
  it { should respond_to(:weight) }
  it { should respond_to(:inventory) }

  it "is valid with an order, line_item, and purchased_at time" do
    expect(cart).to be_valid
  end

  describe 'associations', :vcr do
    it 'has one order' do
      cart = create(:cart)
      order = create(:order, cart: cart)
      expect(cart.order).to eq order
    end

    it 'associated order constrains cart destroy' do
      cart = create(:cart)
      order = create(:order, cart: cart)
      expect {cart.destroy}.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it 'can be destroyed after associated order is destroyed' do
      cart = create(:cart)
      order = create(:order, cart: cart)
      order.destroy
      expect {cart.destroy}.to change {Cart.count}.by(-1)
    end

    it 'has multiple line_items' do
      cart = create(:cart, purchased_at: Time.zone.now)
      create(:line_item, cart: cart)
      create(:line_item, cart: cart)
      expect(cart.line_items.count).to eq 2
    end

    it 'destroys associated line_items' do
      cart = create(:cart)
      create(:line_item, cart: cart)
      create(:line_item, cart: cart)
      expect {cart.destroy}.to change {LineItem.count}.by(-2)
    end

    it 'does not constrain line_item destroy' do
      cart = create(:cart)
      line = create(:line_item, cart: cart)
      expect {line.destroy}.to change {LineItem.count}.by(-1)
    end
  end

  describe 'subtotal' do
    let(:price)     { 100 } # price in dollars
    let(:quantity)  { 3 }
    let(:tag)       { build_stubbed(:size_weight_price_tag, full_price: price) }
    let(:component) { build_stubbed(:component, size_weight_price_tag: tag) }
    let(:line_item) { build_stubbed(:line_item, component: component, quantity: quantity) }
    let(:cart)      { build_stubbed(:cart, line_items: [line_item]) }

    it 'calculates the correct value' do
      expect(cart.subtotal).to eql price * quantity * 100
    end

  end

  describe 'opamp discount' do
    let(:t1) { create(:size_weight_price_tag, full_price: 229, discount_price: 200) }
    let(:c1) { create(:component, mfr_part_number: 'A12KF-2S', size_weight_price_tag: t1) }
    let(:line_1)  { create(:line_item, component: c1, quantity: 1) }
    let(:t2) { create(:size_weight_price_tag, full_price: 249, discount_price: 221) }
    let(:c2) { create(:component, mfr_part_number: 'A12KA-2L', size_weight_price_tag: t2) }
    let(:line_2)  { create(:line_item, component: c2, quantity: 1) }
    let(:t3) { create(:size_weight_price_tag, full_price: 79, discount_price: 50) }
    let(:c3) { create(:component, mfr_part_number: 'SC25KA', size_weight_price_tag: t3) }
    let(:line_3)  { create(:line_item, component: c3, quantity: 1) }
    let(:t4) { create(:size_weight_price_tag, full_price: 79, discount_price: 52) }
    let(:c4) { create(:component, mfr_part_number: 'SC10KA', size_weight_price_tag: t4) }
    let(:line_4)  { create(:line_item, component: c4, quantity: 1) }
    let(:cart)    { create(:cart, line_items: [line_1, line_2, line_3, line_4]) }

    it 'calculates the correct value' do
      expect(cart.discount).to eql (2900 + 2800 + 2900 + 2700)
    end
  end

  describe 'subpanel discount' do
    let(:t1) { create(:size_weight_price_tag, full_price: 100, discount_price: 92) }
    let(:c1) { create(:component, mfr_part_number: 'A12KF-2S', size_weight_price_tag: t1) }
    let(:line_1)  { create(:line_item, component: c1, quantity: 1) }
    let(:t2) { create(:size_weight_price_tag, full_price: 15, discount_price: 10) }
    let(:c2) { create(:component, mfr_part_number: 'CH02-SP-A12', size_weight_price_tag: t2) }
    let(:line_2)  { create(:line_item, component: c2, quantity: 1) }
    let(:cart)    { create(:cart, line_items: [line_1, line_2]) }

    it 'calculates the correct value' do
      expect(cart.discount).to eql (800 + 500)
    end

  end

  describe 'chassis discount' do
    let(:t1) { create(:size_weight_price_tag, full_price: 599, discount_price: 300) }
    let(:c1) { create(:component, mfr_part_number: 'CH02KF', size_weight_price_tag: t1) }
    let(:line_1)  { create(:line_item, component: c1, quantity: 1) }
    let(:t2) { create(:size_weight_price_tag, full_price: 329, discount_price: 299) }
    let(:c2) { create(:component, mfr_part_number: 'N72KF', size_weight_price_tag: t2) }
    let(:line_2)  { create(:line_item, component: c2, quantity: 1) }
    let(:t3) { create(:size_weight_price_tag, full_price: 599, discount_price: 400) }
    let(:c3) { create(:component, mfr_part_number: 'CH02KA-2', size_weight_price_tag: t3) }
    let(:line_3)  { create(:line_item, component: c3, quantity: 1) }
    let(:t4) { create(:size_weight_price_tag, full_price: 279, discount_price: 259) }
    let(:c4) { create(:component, mfr_part_number: 'A12BKA-2H', size_weight_price_tag: t4) }
    let(:line_4)  { create(:line_item, component: c4, quantity: 2) }
    let(:cart)    { create(:cart, line_items: [line_1, line_2, line_3, line_4]) }

    it 'calculates the correct value' do
      expect(cart.discount).to eql (29900 + 3000 + 19900 + 2000)
    end
  end

  describe 'inventory' do
    it 'subtracts quantity from stock' do
      cart = create(:cart)
      component = create(:component, stock: 0)
      item = create(:line_item, component: component, cart: cart)
      cart.inventory
      expect(component.reload.stock).to eq(-item.quantity)
    end
  end
end

