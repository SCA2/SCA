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
  it { should respond_to(:discount) }
  it { should respond_to(:shipping_volume) }
  it { should respond_to(:shipping_weight) }
  it { should respond_to(:extended_price) }
  it { should respond_to(:extended_weight) }
  
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

  describe 'cart associations' do
    it 'has one cart' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect(line_item.cart).to eq cart
    end

    it 'does not destroy associated cart' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect {line_item.destroy}.not_to change {Cart.count}
    end

    it 'does not constrain destruction of associated cart' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect {cart.destroy}.to change {Cart.count}.by(-1)
    end

    it 'is destroyed with destruction of associated cart' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect {cart.destroy}.to change {LineItem.count}.by(-1)
    end
  end

  describe 'product associations' do
    it 'has one product' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect(line_item.product).to eq product
    end

    it 'does not destroy associated product' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect {line_item.destroy}.not_to change {Product.count}
    end

    it 'constrains destruction of associated product' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect {product.destroy}.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it 'associated product can be destroyed after destruction of line_item' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      line_item.destroy
      expect {product.destroy}.to change {Product.count}.by(-1)
    end
  end

  describe 'option associations' do
    it 'has one option' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect(line_item.option).to eq option
    end

    it 'does not destroy associated option' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect {line_item.destroy}.not_to change {Option.count}
    end

    it 'constrains destruction of associated option' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      expect {option.destroy}.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it 'associated option can be destroyed after destruction of line_item' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_item = create(:line_item, cart: cart, product: product, option: option)
      line_item.destroy
      expect {option.destroy}.to change {Option.count}.by(-1)
    end
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