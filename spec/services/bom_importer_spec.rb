require 'rails_helper'

describe BomImporter do

  before do
    create(:product)
  end

  subject { BomImporter.new }
  
  it { should respond_to(:product) }
  it { should respond_to(:products) }
  it { should respond_to(:option) }
  it { should respond_to(:options) }
  it { should respond_to(:bom) }
  it { should respond_to(:file) }
  it { should respond_to(:url) }
end