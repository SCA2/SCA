require 'rails_helper'

describe Cart do
  before do
    @cart = build(:cart)
  end
  
  subject { @cart }

  it { should respond_to(:order) }
  it { should respond_to(:line_items) }
  it { should respond_to(:purchased_at) }

  it { should respond_to(:add_product) }
  it { should respond_to(:discount) }
  it { should respond_to(:combo_discount) }
  it { should respond_to(:subtotal) }
  it { should respond_to(:total_volume) }
  it { should respond_to(:max_dimension) }
  it { should respond_to(:total_items) }
  it { should respond_to(:weight) }
  it { should respond_to(:inventory) }

  it "is valid with an order, line_item, and purchased_at time" do
    expect(@cart).to be_valid
  end

  describe 'associations' do
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
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      create(:line_item, cart: cart, product: product, option: option)
      create(:line_item, cart: cart, product: product, option: option)
      expect(cart.line_items.count).to eq 2
    end

    it 'destroys associated line_items' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      create(:line_item, cart: cart, product: product, option: option)
      create(:line_item, cart: cart, product: product, option: option)
      expect {cart.destroy}.to change {LineItem.count}.by(-2)
    end

    it 'does not constrain line_item destroy' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, cart: cart, product: product, option: option)
      expect {line.destroy}.to change {LineItem.count}.by(-1)
    end
  end

end

