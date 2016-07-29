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
      create(:transaction, order: order)
      expect {order.destroy}.to change {Transaction.count}.by(-1)
    end
  end

  describe 'response=' do
    it 'handles successful transaction assignment' do
      response = double
      expect(response).to receive(:success?).and_return(true)
      expect(response).to receive(:authorization)
      expect(response).to receive(:message)
      expect(response).to receive(:params)
      transaction = create(:transaction)
      transaction.response = response
      expect(transaction.success).to be true
    end

    it 'handles unsuccessful transaction assignment' do
      response = double
      expect(response).to receive(:success?).and_return(false)
      expect(response).to receive(:authorization)
      expect(response).to receive(:message)
      expect(response).to receive(:params)
      transaction = create(:transaction)
      transaction.response = response
      expect(transaction.success).to be false
    end

    it 'handles invalid response' do
      response = double
      expect(response).not_to receive(:success?)
      expect(response).not_to receive(:authorization)
      expect(response).not_to receive(:message)
      expect(response).not_to receive(:params)
      transaction = create(:transaction)
      transaction.response = nil
      expect(transaction.message).to eq "invalid response"
    end
  end
end
