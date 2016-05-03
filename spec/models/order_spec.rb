require 'rails_helper'

describe Order do

  it "has a valid factory" do
    expect(build(:order)).to be_valid
  end

  let(:order) {build(:order) }

  it { should respond_to(:cart) }
  it { should respond_to(:addresses) }
  it { should respond_to(:transactions) }

  it { should respond_to(:email) }
  it { should respond_to(:card_type) }
  it { should respond_to(:card_expires_on) }
  it { should respond_to(:express_token) }
  it { should respond_to(:express_payer_id) }
  it { should respond_to(:shipping_method) }
  it { should respond_to(:shipping_cost) }

  it { should respond_to(:purchase) }
  it { should respond_to(:express_token) }
  it { should respond_to(:get_express_address) }
  it { should respond_to(:total) }
  it { should respond_to(:subtotal) }
  # it { should respond_to(:subtotal_in_cents) }
  it { should respond_to(:origin) }
  it { should respond_to(:destination) }
  it { should respond_to(:packages) }
  it { should respond_to(:prune_response) }
  it { should respond_to(:get_rates_from_shipper) }
  it { should respond_to(:get_rates_from_params) }
  it { should respond_to(:ups_rates) }
  it { should respond_to(:usps_rates) }
  it { should respond_to(:sales_tax) }
  it { should respond_to(:dimensions) }

  it { should respond_to(:card_number) }
  it { should respond_to(:card_verification) }
  it { should respond_to(:ip_address) }
  it { should respond_to(:validate_order) }
  it { should respond_to(:validate_terms) }
  it { should respond_to(:accept_terms) }

  describe 'subtotal' do
    let(:price)     { 100 } # price in dollars
    let(:quantity)  { 3 }
    let(:product)   { build_stubbed(:product) }
    let(:option)    { build_stubbed(:option, price: price, product: product) }
    let(:line_item) do
      build_stubbed(:line_item,
        product: product,
        option: option,
        quantity: quantity
      )
    end
    let(:cart)      { build_stubbed(:cart, line_items: [line_item]) }
    let(:order)     { build_stubbed(:order, cart: cart) }

    it 'calculates the correct value' do
      expect(order.subtotal).to eql price * quantity * 100
    end

  end

  describe 'sales_tax' do
    let(:price)     { 100 } # price in dollars
    let(:quantity)  { 3 }
    let(:rate)      { 0.09 }
    let(:product)   { build_stubbed(:product) }
    let(:option)    { build_stubbed(:option, price: price, product: product) }
    let(:line_item) { build_stubbed(:line_item,
      product: product,
      option: option,
      quantity: quantity)
    }
    let(:cart)      { build_stubbed(:cart, line_items: [line_item]) }
    let(:order)     { build_stubbed(:order, cart: cart) }

    it 'calculates the correct value for CA' do
      shipping = create(:shipping, state_code: 'CA', address_type: 'shipping', addressable: order)
      expect(order.sales_tax).to eql (price * 100 * quantity * rate).round
    end

    it 'calculates value of 0 for other states' do
      shipping = create(:shipping, state_code: 'PA', address_type: 'shipping', addressable: order)
      expect(order.sales_tax).to eql 0
    end
  end

end