require 'spec_helper'

describe Feature do

  let(:product) { FactoryGirl.create(:product) }
  before do
    @feature = product.features.build(
                      model: 'A12KF',
                      caption: 'Caption',
                      sort_order: 10,
                      description: 'Description')
  end
  
  subject { @feature }
  
  it { should respond_to(:product_id) }
  it { should respond_to(:model) }
  it { should respond_to(:caption) }
  it { should respond_to(:sort_order) }
  it { should respond_to(:description) }
  
  its(:product) { should eq product }
  
  it { should be_valid }
  
  describe 'when product_id is not present' do
    before { @feature.product_id = nil }
    it { should_not be_valid }
  end
  
  describe 'with no model' do
    before { @feature.model = nil }
    it { should_not be_valid }
  end

  describe 'with no caption' do
    before { @feature.caption = nil }
    it { should_not be_valid }
  end

  describe 'with no sort_order' do
    before { @feature.sort_order = nil }
    it { should_not be_valid }
  end

  describe 'with no description' do
  end
end
