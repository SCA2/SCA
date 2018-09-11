require 'rails_helper'

describe LineItem do

  let(:cart) { create(:cart) }
  let(:line_item) { build_stubbed(:line_item, cart: cart) }

  subject { line_item }
  
  it { should be_valid }

  it { should respond_to(:option) }
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
  
  describe 'when itemizable_id is not present' do
    before { line_item.itemizable_id = nil }
    it { should_not be_valid }
  end

  describe 'when itemizable_type is not present' do
    before { line_item.itemizable_type = nil }
    it { should_not be_valid }
  end

  describe 'when cart_id is not present' do
    before { line_item.cart_id = nil }
    it { should_not be_valid }
  end

  describe 'cart associations' do
    it 'has one cart' do
      cart = create(:cart)
      option = create(:option)
      line_item = build_stubbed(:line_item, cart: cart, itemizable: option)
      expect(line_item.cart).to eq cart
    end

    it 'does not destroy associated cart' do
      cart = create(:cart, purchased_at: Time.now)
      option = create(:option)
      line_item = create(:line_item, cart: cart, itemizable: option)
      expect {line_item.destroy}.not_to change {Cart.count}
    end

    it 'does not constrain destruction of associated cart' do
      cart = create(:cart)
      option = create(:option)
      line_item = build_stubbed(:line_item, cart: cart, itemizable: option)
      expect {cart.destroy}.to change {Cart.count}.by(-1)
    end

    it 'is destroyed with destruction of associated cart' do
      cart = create(:cart)
      option = create(:option)
      line_item = create(:line_item, cart: cart, itemizable: option)
      expect {cart.destroy}.to change {LineItem.count}.by(-1)
    end
  end

  describe 'option associations' do
    it 'has one option' do
      cart = create(:cart)
      option = create(:option)
      line_item = create(:line_item, cart: cart, itemizable: option)
      expect(line_item.option).to eq option
    end

    it 'does not destroy associated option' do
      cart = create(:cart)
      option = create(:option)
      line_item = create(:line_item, cart: cart, itemizable: option)
      expect {line_item.destroy}.not_to change {Option.count}
    end

    it 'constrains destruction of associated option' do
      cart = create(:cart)
      option = create(:option)
      line_item = create(:line_item, cart: cart, itemizable: option)
      expect {option.destroy}.to raise_error(ActiveRecord::DeleteRestrictionError)
    end

    it 'associated option can be destroyed after destruction of line_item' do
      cart = create(:cart)
      option = create(:option)
      line_item = create(:line_item, cart: cart, itemizable: option)
      line_item.destroy
      expect {option.destroy}.to change {Option.count}.by(-1)
    end
  end

  describe 'product and option calculations' do
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
    let(:option)    { build_stubbed(:option, component: component) }
    let(:line_item) { build_stubbed(:line_item, itemizable: option, quantity: quantity) }

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