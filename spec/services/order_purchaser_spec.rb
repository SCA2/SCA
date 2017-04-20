require 'rails_helper'

describe OrderPurchaser do

  context 'with valid card' do
    
    let(:good_token) do
      Stripe::Token.create(
        card: {
          number: "4242424242424242",
          exp_month: Date.today.month,
          exp_year: Date.today.next_year.year,
          cvc: 314
        }
      ).id
    end

    let(:order) { create(:order, stripe_token: good_token, express_token: nil) }
    
    it 'purchases the order', :vcr do
      allow(order).to receive(:total) { 999 }
      allow(order).to receive(:stripe_purchase?) { true }
      expect(OrderPurchaser.new(order).purchase).to be true
    end

    it 'records a successful transaction', :vcr do
      allow(order).to receive(:total) { 999 }
      allow(order).to receive(:stripe_purchase?) { true }
      OrderPurchaser.new(order).purchase
      expect(order.transactions.count).to eq 1
      expect(order.transactions.last.authorization).to eq 'ch_1A4IsHFC0i7e7XIPBR8Hi3Dc'
      expect(order.transactions.last.action).to eq 'stripe purchase'
      expect(order.transactions.last.amount).to eq 999
      expect(order.transactions.last.success).to be true
    end
  end

  context 'with invalid card' do
    
    let(:bad_token) do
      Stripe::Token.create(
        card: {
          number: "4000000000000002",
          exp_month: Date.today.month,
          exp_year: Date.today.next_year.year,
          cvc: 314
        }
      ).id
    end

    let(:order) { create(:order, stripe_token: bad_token, express_token: nil) }

    it 'does not purchase the order', :vcr do
      allow(order).to receive(:total) { 999 }
      allow(order).to receive(:stripe_purchase?) { true }
      expect(OrderPurchaser.new(order).purchase).to be false
    end

    it 'records a failed transaction', :vcr do
      allow(order).to receive(:total) { 999 }
      allow(order).to receive(:stripe_purchase?) { true }
      OrderPurchaser.new(order).purchase
      expect(order.transactions.count).to eq 1
      expect(order.transactions.last.action).to eq 'exception'
      expect(order.transactions.last.amount).to eq 999
      expect(order.transactions.last.success).to be false
    end
  end
end
