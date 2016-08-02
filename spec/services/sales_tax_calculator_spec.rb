require 'rails_helper'

describe SalesTaxCalculator do

  subject { SalesTaxCalculator.new }

  it { should respond_to(:all_orders) }
  it { should respond_to(:gross_sales) }
  it { should respond_to(:taxable_sales) }
  it { should respond_to(:excluded_sales) }
  it { should respond_to(:excluded_shipping) }
  it { should respond_to(:tax_withheld) }

  before do
    3.times do
      product = create(:product)
      option = create(:option, price: 100, product: product)
      line_item = create(:line_item, quantity: 1, product: product, option: option)
      line_item.cart.update(purchased_at: Date.today.noon)
      order = create(:order, shipping_cost: 1500, cart: line_item.cart)
      order.addresses << build(:address, addressable: order, address_type: 'shipping')
      order.addresses << build(:address, addressable: order, address_type: 'billing', state_code: 'CA')
      order.save
      order.addresses.each { |address| address.save }
      create(:transaction, order: order)
    end
    2.times do
      product = create(:product)
      option = create(:option, price: 200, product: product)
      line_item = create(:line_item, quantity: 1, product: product, option: option)
      line_item.cart.update(purchased_at: Date.today.noon)
      order = create(:order, shipping_cost: 1500, cart: line_item.cart)
      order.addresses << build(:address, addressable: order, address_type: 'shipping')
      order.addresses << build(:address, addressable: order, address_type: 'billing', state_code: 'PA')
      order.save
      order.addresses.each { |address| address.save }
      create(:transaction, order: order)
    end
  end

  it 'finds taxable orders within date range' do
    tax = SalesTaxCalculator.new(Date.yesterday..Date.tomorrow)
    expect(tax.all_orders.to_a).to eq Order.all.to_a
  end

  it 'calculates gross sales within date range' do
    tax = SalesTaxCalculator.new(Date.yesterday..Date.tomorrow)
    expect(tax.gross_sales).to eq 84150
  end

  it 'calculates taxable sales within date range' do
    tax = SalesTaxCalculator.new(Date.yesterday..Date.tomorrow)
    expect(tax.taxable_sales).to eq 37350
  end

  it 'calculates excluded sales within date range' do
    tax = SalesTaxCalculator.new(Date.yesterday..Date.tomorrow)
    expect(tax.excluded_sales).to eq 46800
  end

  it 'calculates excluded shipping within date range' do
    tax = SalesTaxCalculator.new(Date.yesterday..Date.tomorrow)
    expect(tax.excluded_shipping).to eq 4500
  end

  it 'calculates sales tax withheld within date range' do
    tax = SalesTaxCalculator.new(Date.yesterday..Date.tomorrow)
    expect(tax.tax_withheld).to eq 2850
  end
end