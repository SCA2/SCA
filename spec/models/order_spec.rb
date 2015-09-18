require 'rails_helper'

describe Order do

  it "has a valid factory" do
    expect(FactoryGirl.build(:order)).to be_valid
  end

  let(:order) { FactoryGirl.build(:order) }

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
  it { should respond_to(:total_in_cents) }
  it { should respond_to(:subtotal) }
  it { should respond_to(:subtotal_in_cents) }
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

end