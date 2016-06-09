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

  describe 'associations', :vcr do
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

  describe 'response=', :vcr do
    before do
      # ::STANDARD_GATEWAY = ActiveMerchant::Billing::BogusGateway.new()
      @total = 100
      @standard_purchase_options = {
        ip: '127.0.0.1',
        billing_address: {
          name:       'Joe Tester',
          address1:   '1234 Main Street',
          city:       'Oakland',
          state_code: 'CA',
          country:    'US',
          zip:        '94612'
        }
      }
    end

    it 'handles valid transaction assignment' do
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        brand:              'VISA',
        number:             '4032038036005571',
        verification_value: '123',
        month:              '12',
        year:               '2019',
        first_name:         'Joe',
        last_name:          'Tester'
      )
      transaction = create(:transaction)
      transaction.response = STANDARD_GATEWAY.purchase(@total, credit_card, @standard_purchase_options)
      expect(transaction.success).to be true
    end

    it 'handles invalid transaction assignment' do
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        brand:              'VISA',
        number:             '4032038036005573',
        verification_value: '123',
        month:              '12',
        year:               '2019',
        first_name:         'Joe',
        last_name:          'Tester'
      )
      transaction = create(:transaction)
      expect { transaction.response = STANDARD_GATEWAY.purchase(@total, credit_card, @standard_purchase_options) }.to raise_error
    end
  end
end
