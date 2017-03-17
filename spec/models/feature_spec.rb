require 'rails_helper'

describe Feature do
  
  let(:feature) { build(:feature) }

  subject { feature }

  it { should be_valid }  
  it { should respond_to(:caption) }
  it { should respond_to(:description) }
  it { should respond_to(:product_id) }
  it { should respond_to(:sort_order) }

  context 'invalid without' do
  
    it 'caption' do
      expect(build(:feature, :caption => nil)).not_to be_valid
    end

    it 'description' do
      expect(build(:feature, :description => nil)).not_to be_valid
    end
    it 'product_id' do
      expect(build(:feature, :product_id => nil)).not_to be_valid
    end
    
    it 'sort_order' do
      expect(build(:feature, :sort_order => nil)).not_to be_valid
    end

  end

  context 'has association' do
    
    let(:product) { create(:product) }
    
    it 'with product' do
      product.features << feature
      expect(product.features.first).to eql feature
    end
  end

end
