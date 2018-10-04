require 'rails_helper'

describe LineItem do

  let(:cart) { create(:cart) }
  let(:line_item) { build_stubbed(:line_item, cart: cart) }

  subject { line_item }
  
  it { should be_valid }

  it { should respond_to(:component) }
  it { should respond_to(:cart) }
  it { should respond_to(:quantity) }
    
  it { should respond_to(:item_model) }
  it { should respond_to(:item_description) }
  it { should respond_to(:full_price_in_cents) }
  it { should respond_to(:discount_price_in_cents) }
  it { should respond_to(:shipping_volume) }
  it { should respond_to(:shipping_weight) }
  it { should respond_to(:extended_price) }
  it { should respond_to(:extended_weight) }
  
  describe 'when component_id is not present' do
    before { line_item.component_id = nil }
    it { should_not be_valid }
  end

  describe 'when cart_id is not present' do
    before { line_item.cart_id = nil }
    it { should_not be_valid }
  end

  describe 'cart associations' do
    it 'has one cart' do
      cart = create(:cart)
      component = create(:component)
      line_item = build_stubbed(:line_item, cart: cart, component: component)
      expect(line_item.cart).to eq cart
    end

    it 'does not destroy associated cart' do
      cart = create(:cart, purchased_at: Time.now)
      component = create(:component)
      line_item = create(:line_item, cart: cart, component: component)
      expect {line_item.destroy}.not_to change {Cart.count}
    end

    it 'does not constrain destruction of associated cart' do
      cart = create(:cart)
      component = create(:component)
      line_item = build_stubbed(:line_item, cart: cart, component: component)
      expect {cart.destroy}.to change {Cart.count}.by(-1)
    end

    it 'is destroyed with destruction of associated cart' do
      cart = create(:cart)
      component = create(:component)
      line_item = create(:line_item, cart: cart, component: component)
      expect {cart.destroy}.to change {LineItem.count}.by(-1)
    end
  end

  describe 'component associations' do
    it 'has one component' do
      cart = create(:cart)
      component = create(:component)
      line_item = create(:line_item, cart: cart, component: component)
      expect(line_item.component).to eq component
    end

    it 'does not destroy associated component' do
      cart = create(:cart)
      component = create(:component)
      line_item = create(:line_item, cart: cart, component: component)
      expect {line_item.destroy}.not_to change {Component.count}
    end

    it 'existence constrains destruction of associated component' do
      cart = create(:cart)
      component = create(:component)
      line_item = create(:line_item, cart: cart, component: component)
      expect {component.destroy}.to raise_error(ActiveRecord::DeleteRestrictionError)
    end

    it 'associated component can be destroyed after destruction of line_item' do
      cart = create(:cart)
      component = create(:component)
      line_item = create(:line_item, cart: cart, component: component)
      line_item.destroy
      expect {component.destroy}.to change {Component.count}.by(-1)
    end
  end

  describe 'product and component calculations' do
    let(:price)     { 100 } # price in dollars
    let(:quantity)  { 3 }
    let(:weight)    { 2 }
    let(:tag)       { build_stubbed(:size_weight_price_tag,
      full_price: price,
      shipping_weight: weight,
      shipping_length: 2,
      shipping_width: 2,
      shipping_height: 2
    )}
    let(:component) { build_stubbed(:component, size_weight_price_tag: tag)}
    let(:line_item) { build_stubbed(:line_item, component: component, quantity: quantity) }

    it 'returns the tag price' do
      expect(line_item.full_price_in_cents).to eql tag.full_price_in_cents
    end

    it 'calculates extended_price' do
      expect(line_item.extended_price).to eql tag.full_price_in_cents * quantity
    end
    
    it 'calculates extended_weight' do
      expect(line_item.extended_weight).to eql tag.shipping_weight * quantity
    end

    it 'calculates shipping volume' do
      expect(line_item.shipping_volume).to eq(24)
    end
  end

end