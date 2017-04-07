require 'rails_helper'

describe BomImporter do
  let(:order) { build(:order) }
  
  subject { BomImporter.new(order, {}) }
  
  it { should respond_to(:product) }
  it { should respond_to(:products) }
  it { should respond_to(:option) }
  it { should respond_to(:options) }
  it { should respond_to(:bom) }
  it { should respond_to(:file) }
  it { should respond_to(:url) }
end