require 'rails_helper'

describe OrderPurchaser do

  let(:order) { build_stubbed(:order) }
  subject { OrderPurchaser.new(order) }

  it { should respond_to(:purchase) }
end