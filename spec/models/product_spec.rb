require 'spec_helper'

describe Product do

  before do
    @product = Product.new( model: 'A12',
                            model_weight: 10,
                            category: 'Microphone Preamp',
                            category_weight: 10,
                            short_description: 'Short description',
                            long_description: 'Long description',
                            image_1: 'image_url',
                            upc: 1234567890,
                            price: 249 )
  end
  
  subject { @product }
  
  it { should respond_to(:category) }
  it { should respond_to(:category_weight) }
  it { should respond_to(:model) }
  it { should respond_to(:model_weight) }
  it { should respond_to(:short_description) }
  it { should respond_to(:long_description) }
  it { should respond_to(:notes) }
  it { should respond_to(:upc) }
  it { should respond_to(:image_1) }
  it { should respond_to(:image_2) }
  it { should respond_to(:price) }
  it { should respond_to(:features) }

  describe 'feature associations' do
    before { @product.save }
    let!(:first_feature) do
      FactoryGirl.create(:feature, product: @product, caption_sort_order: 10)
    end
    let!(:last_feature) do
      FactoryGirl.create(:feature, product: @product, caption_sort_order: 100)
    end
    
    it 'should have the features sorted by caption_sort_order' do
      expect(@product.features.to_a).to eq [first_feature, last_feature]
    end
    
    it 'should destroy associated features' do
      features = @product.features.to_a
      @product.destroy
      expect(features).not_to be_empty
      features.each do |feature| 
        expect(Feature.where(id: feature.id)).to be_empty
      end
    end
  end
end
