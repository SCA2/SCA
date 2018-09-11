require 'rails_helper'

describe BomImporter do

  subject { BomImporter.new }
  
  it { should respond_to(:component) }
  it { should respond_to(:components) }
  it { should respond_to(:bom) }
  it { should respond_to(:file) }
  it { should respond_to(:url) }
end