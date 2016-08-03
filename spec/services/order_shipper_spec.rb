require 'rails_helper'

describe OrderShipper do
  VCR.configure do |c|
    c.default_cassette_options = {
      :match_requests_on => [:method, VCR.request_matchers.uri_without_param(:AcceptanceDateTime)]
    }
  end

  let(:order) { build_stubbed(:order) }
  subject { OrderShipper.new(order) }

  it { should respond_to(:destination) }
  it { should respond_to(:package) }
  it { should respond_to(:get_rates_from_shipper) }
  it { should respond_to(:get_rates_from_params) }
  it { should respond_to(:ups_rates) }
  it { should respond_to(:usps_rates) }
  it { should respond_to(:dimensions) }

  it 'returns USPS rates for non-US address', :vcr do
    order = instance_double(Order)
    allow(order).to receive(:min_dimension).and_return(2)
    allow(order).to receive(:max_dimension).and_return(10)
    allow(order).to receive(:total_volume).and_return(11*8*5)
    allow(order).to receive(:shipping_address).and_return(build(:shipping_AU))
    allow(order).to receive(:weight).and_return(3)
    allow(order).to receive(:subtotal).and_return(32900)
    rates = OrderShipper.new(order).usps_rates
    expect(rates).not_to be nil
  end

  it 'does not return USPS rates for US address', :vcr do
    order = instance_double(Order)
    allow(order).to receive(:min_dimension).and_return(2)
    allow(order).to receive(:max_dimension).and_return(10)
    allow(order).to receive(:total_volume).and_return(12*9*6)
    allow(order).to receive(:shipping_address).and_return(build(:shipping_US))
    allow(order).to receive(:weight).and_return(3)
    allow(order).to receive(:subtotal).and_return(32900)
    rates = OrderShipper.new(order).usps_rates
    expect(rates).to eq []
  end

  it 'returns USPS rates for small flat rate box', :vcr do
    order = instance_double(Order)
    allow(order).to receive(:min_dimension).and_return(1)
    allow(order).to receive(:max_dimension).and_return(2)
    allow(order).to receive(:total_volume).and_return(2*2*1)
    allow(order).to receive(:shipping_address).and_return(build(:shipping_US))
    allow(order).to receive(:weight).and_return(1)
    allow(order).to receive(:subtotal).and_return(7900)
    shipper = OrderShipper.new(order)
    rates = shipper.usps_rates
    expect(rates.length).not_to eq []
  end
end