require 'rails_helper'

describe Transaction do
  
  let(:transaction) { create(:transaction) }

  it { should respond_to(:response=) }
  it { should respond_to(:action) }
  it { should respond_to(:amount) }
  it { should respond_to(:success) }
  it { should respond_to(:authorization) }
  it { should respond_to(:message) }
  it { should respond_to(:params) }

  describe 'associations' do
    it 'belongs to one order' do
      order = create(:order)
      transaction = create(:transaction, order: order)
      expect(transaction.order).to eq order
      expect(order.transactions.first).to eq transaction
    end

    it 'does not destroy its associated order' do
      order = create(:order)
      transaction = create(:transaction, order: order)
      expect {transaction.destroy}.not_to change {Order.count}
    end

    it 'is destroyed by its associated order' do
      order = create(:order)
      transaction = create(:transaction, order: order)
      expect {order.destroy}.to change {Transaction.count}.by(-1)
    end
  end
end
