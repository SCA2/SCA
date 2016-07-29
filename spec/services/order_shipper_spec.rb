require 'rails_helper'

describe OrderShipper do

  let(:order) { build_stubbed(:order) }
  subject { OrderShipper.new(order) }

  it { should respond_to(:origin) }
  it { should respond_to(:destination) }
  it { should respond_to(:packages) }
  it { should respond_to(:prune_response) }
  it { should respond_to(:get_rates_from_shipper) }
  it { should respond_to(:get_rates_from_params) }
  it { should respond_to(:ups_rates) }
  it { should respond_to(:usps_rates) }
  it { should respond_to(:dimensions) }

end