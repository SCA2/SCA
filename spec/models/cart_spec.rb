require 'rails_helper'

describe Cart do
  before do
    @cart = build(:cart)
  end
  
  subject { @cart }

  it { should respond_to(:order) }
  it { should respond_to(:line_items) }
  it { should respond_to(:purchased_at) }

  it { should respond_to(:add_product) }
  it { should respond_to(:discount) }
  it { should respond_to(:combo_discount) }
  it { should respond_to(:subtotal) }
  it { should respond_to(:total_volume) }
  it { should respond_to(:max_dimension) }
  it { should respond_to(:total_items) }
  it { should respond_to(:weight) }
  it { should respond_to(:inventory) }

  it "is valid with an order, line_item, and purchased_at time" do
    expect(@cart).to be_valid
  end

end

