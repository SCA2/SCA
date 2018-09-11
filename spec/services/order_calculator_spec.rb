require 'rails_helper'

describe OrderCalculator do
  describe 'sales_tax' do
    let(:price)       { 100 } # price in dollars
    let(:quantity)    { 3 }
    let(:rate)        { 0.0925 }
    let(:tag)         { build(:size_weight_price_tag, full_price: price) }
    let(:component)   { build(:component, size_weight_price_tag: tag) }
    let(:line_item)   { build(:line_item, itemizable: component, quantity: quantity) }
    let(:order)       { build(:order) }
    let(:calculator)  { OrderCalculator.new(order) }

    it 'calculates the correct value for CA' do
      order.cart.line_items << line_item
      create(:billing, state_code: 'CA', address_type: 'billing', addressable: order)
      expect(calculator.sales_tax).to eql (price * 100 * quantity * rate).round
    end

    it 'calculates value of 0 for other states' do
      create(:billing, state_code: 'PA', address_type: 'billing', addressable: order)
      expect(calculator.sales_tax).to eql 0
    end
  end

  describe 'total' do
    let(:price)       { 100 } # price in dollars
    let(:quantity)    { 3 }
    let(:tag)         { build(:size_weight_price_tag, full_price: price) }
    let(:component)   { build(:component, size_weight_price_tag: tag) }
    let(:line_item)   { build(:line_item, itemizable: component, quantity: quantity) }
    let(:order)       { build(:order, shipping_cost: 1500) }
    let(:calculator)  { OrderCalculator.new(order) }

    it 'calculates the correct value' do
      order.cart.line_items << line_item
      create(:billing, state_code: 'CA', address_type: 'billing', addressable: order)
      total = price * quantity * 100
      total *= 1.0925
      total += order.shipping_cost
      expect(calculator.total).to eql total.round
    end
  end
end