require 'spec_helper'

describe Feature do
  let(:product) { FactoryGirl.create(:product) }
  before { @feature = product.features.build(
                      model: 'A12KF',
                      caption: 'Caption',
                      caption_sort_order: 10,
                      short_description: 'Short description',
                      long_description: 'Long description') }
  
  subject { @feature }
  
  it { should respond_to(:product_id) }
  it { should respond_to(:model) }
  it { should respond_to(:caption) }
  it { should respond_to(:caption_sort_order) }
  it { should respond_to(:short_description) }
  it { should respond_to(:long_description) }
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

  describe 'with no caption_sort_order' do
    before { @feature.caption_sort_order = nil }
    it { should_not be_valid }
  end

  describe 'with no short_description' do
    before { @feature.short_description = nil }
    it { should_not be_valid }
  end

  describe 'with no long_description' do
    before { @feature.long_description = nil }
    it { should_not be_valid }
  end

end
