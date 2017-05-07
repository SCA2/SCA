require 'rails_helper'

describe Order do

  let(:order) { build(:order) }

  it { should respond_to(:cart) }
  it { should respond_to(:addresses) }
  it { should respond_to(:transactions) }

  it { should respond_to(:billing_address) }
  it { should respond_to(:shipping_address) }

  it { should respond_to(:purchased?) }
  it { should respond_to(:addressable?) }
  it { should respond_to(:shippable?) }
  it { should respond_to(:confirmable?) }
  it { should respond_to(:transactable?) }
  it { should respond_to(:stripe_purchase?) }
  it { should respond_to(:express_purchase?) }
  it { should respond_to(:transactable?) }

  it { should respond_to(:purchased_at) }
  it { should respond_to(:subtotal) }
  it { should respond_to(:total) }
  it { should respond_to(:min_dimension) }
  it { should respond_to(:max_dimension) }
  it { should respond_to(:total_volume) }

  it { should respond_to(:email) }
  it { should respond_to(:ip_address) }
  it { should respond_to(:stripe_token) }
  it { should respond_to(:express_token) }
  it { should respond_to(:express_payer_id) }
  it { should respond_to(:shipping_method) }
  it { should respond_to(:shipping_cost) }
  it { should respond_to(:sales_tax) }
  it { should respond_to(:use_billing) }
  it { should respond_to(:carrier) }
  it { should respond_to(:ship_date) }
  it { should respond_to(:tracking_number) }
  it { should respond_to(:name) }

  describe 'cart associations' do
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
      cart = create(:cart)
      create(:order, cart: cart)
      expect {cart.destroy}.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end

  describe 'transaction associations' do
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

  describe 'address associations' do
    it 'destroys assocated addresses' do
      order = create(:order)
      create(:address, address_type: 'billing', addressable: order)
      create(:address, address_type: 'shipping', addressable: order)
      expect {order.destroy}.to change {Address.count}.by(-2)
    end
  end

  describe 'scopes' do
    before do
      5.times do
        cart = create(:cart, purchased_at: Date.yesterday)
        order = create(:order, cart: cart)
        create(:billing, addressable: order)
        create(:shipping, addressable: order)
        create(:transaction, order: order)
      end
    end

    describe 'checked_out' do
      it 'finds orders with cart, addresses, shipping, confirmation, token, and transaction' do
        expect(Order.checked_out.to_a.count).to eq(5)
      end

      it 'finds orders with successful transactions' do
        Order.last.transactions.last.update_attribute(:success, false)
        expect(Order.successful.to_a.count).to eq(4)
      end

      it 'finds orders with failed transactions' do
        Order.last.transactions.last.update_attribute(:success, false)
        expect(Order.failed.to_a.count).to eq(1)
      end

      it 'finds orders pending shipment' do
        expect(Order.pending.to_a.count).to eq(0)
        Order.last.transactions.last.update_attribute(:tracking_number, nil)
        Order.last.transactions.last.update_attribute(:shipped_at, nil)
        expect(Order.pending.to_a.count).to eq(1)
      end
    end
  end
end