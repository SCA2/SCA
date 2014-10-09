require 'spec_helper'

describe Cart do
  before do
    @cart = build(:cart)
  end
  
  subject { @cart }

  it { should respond_to(:order) }
  it { should respond_to(:line_items) }
  it { should respond_to(:purchased_at) }

  it "is valid with an order, line_item, and purchased_at time" do
    expect(@cart).to be_valid
  end

end
