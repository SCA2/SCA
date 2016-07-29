require 'rails_helper'

describe Order do

  it "has a valid factory", :vcr do
    expect(build(:order)).to be_valid
  end

  it { should respond_to(:cart) }
  it { should respond_to(:addresses) }
  it { should respond_to(:transactions) }

  it { should respond_to(:billing_address) }
  it { should respond_to(:shipping_address) }

  it { should respond_to(:purchased?) }
  it { should respond_to(:addressable?) }
  it { should respond_to(:shippable?) }
  it { should respond_to(:confirmable?) }
  it { should respond_to(:notifiable?) }
  it { should respond_to(:standard_purchase?) }
  it { should respond_to(:express_purchase?) }

  it { should respond_to(:purchased_at) }
  it { should respond_to(:subtotal) }
  it { should respond_to(:total) }

  it { should respond_to(:email) }
  it { should respond_to(:ip_address) }
  it { should respond_to(:express_token) }
  it { should respond_to(:express_payer_id) }
  it { should respond_to(:shipping_method) }
  it { should respond_to(:shipping_cost) }
  it { should respond_to(:sales_tax) }
  it { should respond_to(:use_billing) }

  describe 'cart associations', :vcr do
    it 'belongs to one cart' do
      order = create(:order)
      cart = create(:cart, order: order)
      expect(order.cart).to eq cart
    end

    it 'order destroy does not destroy associated cart' do
      order = create(:order)
      cart = create(:cart, order: order)
      expect {order.destroy}.not_to change {Cart.count}
    end

    it 'constrains destruction of associated cart' do
      order = create(:order)
      cart = create(:cart, order: order)
      expect {cart.destroy}.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end

  describe 'transaction associations', :vcr do
    it 'can have multiple transactions' do
      order = create(:order)
      create(:transaction, order: order)
      create(:transaction, order: order)
      expect(order.transactions.count).to eq 2
    end

    it 'order destroy also destroys associated transactions' do
      order = create(:order)
      create(:transaction, order: order)
      create(:transaction, order: order)
      expect {order.destroy}.to change {Transaction.count}.by(-2)
    end
  end

  describe 'address associations', :vcr do
    it 'destroys assocated addresses' do
      order = create(:order)
      create(:address, address_type: 'billing', addressable: order)
      create(:address, address_type: 'shipping', addressable: order)
      expect {order.destroy}.to change {Address.count}.by(-2)
    end
  end
end