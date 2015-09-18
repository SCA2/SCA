require 'rails_helper'

describe Product do

  it "has a valid factory" do
    expect(FactoryGirl.build(:product)).to be_valid
  end

  let(:product) { FactoryGirl.build(:product) }
  let(:cart) { FactoryGirl.build_stubbed(:cart) }
  let(:option) { FactoryGirl.build_stubbed(:option) }

  it { should respond_to(:model) }
  it { should respond_to(:short_description) }
  it { should respond_to(:long_description) }
  it { should respond_to(:image_1) }
  it { should respond_to(:image_2) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
  it { should respond_to(:category) }
  it { should respond_to(:category_sort_order) }
  it { should respond_to(:model_sort_order) }
  it { should respond_to(:notes) }
  it { should respond_to(:bom) }
  it { should respond_to(:schematic) }
  it { should respond_to(:assembly) }
  it { should respond_to(:specifications ) }

  it "is invalid without a model" do
    expect(Product.new(model: nil)).to have(1).errors_on(:model)
  end

  it "is invalid without a model_sort_order" do
    expect(Product.new(model_sort_order: nil)).to have(1).errors_on(:model_sort_order)
  end

  it "is invalid without a category" do
    expect(Product.new(category: nil)).to have(1).errors_on(:category)
  end

  it "is invalid without a category_sort_order" do
    expect(Product.new(category_sort_order: nil)).to have(1).errors_on(:category_sort_order)
  end

  it "is invalid without a short_description" do
    expect(Product.new(short_description: nil)).to have(1).errors_on(:short_description)
  end

  it "is invalid without a long_description" do
    expect(Product.new(long_description: nil)).to have(1).errors_on(:long_description)
  end

  it "is invalid without image_1" do
    expect(Product.new(image_1: nil)).to have(1).errors_on(:image_1)
  end

  describe 'category sorting'

  describe 'model sorting'

  describe 'feature associations' do

    let(:first_feature) { FactoryGirl.create(:feature, sort_order: 10) }
    let(:last_feature)  { FactoryGirl.create(:feature, sort_order: 100) }

    before do
      product.features << first_feature
      product.features << last_feature
      product.save
    end

    it 'should have two features' do
      expect(product.features.count).to eq 2
    end
    
    it 'should have two features sorted by sort_order' do
      expect(product.features.to_a).to eq [first_feature, last_feature]
    end
    
    it 'should destroy associated features' do
      features = product.features.to_a
      product.destroy
      expect(features).not_to be_empty
      features.each do |feature| 
        expect(Feature.where(id: feature.id)).to be_empty
      end
    end
  end

  describe 'option associations' do

    let(:first_option) { FactoryGirl.create(:option, product: product, sort_order: 10) }
    let(:last_option) { FactoryGirl.create(:option, product: product, sort_order: 100) }

    before do
      product.save
      product.options << first_option
      product.options << last_option
    end

    it 'should have two options' do
      expect(product.options.count).to eq 2
    end

    it 'should have the options sorted by sort_order' do
      expect(product.options.to_a).to eq [first_option, last_option]
    end
    
    it 'should destroy associated options' do
      options = product.options.to_a
      product.destroy
      expect(options).not_to be_empty
      options.each do |option| 
        expect(Feature.where(id: option.id)).to be_empty
      end
    end
  end

  describe 'line_item associations' do

    # let(:cart) { FactoryGirl.build_stubbed(:cart) }
    # let(:option) { FactoryGirl.build_stubbed(:option) }
    let(:line_item_1) { FactoryGirl.build(:line_item, product: product, option: option, cart: cart) }
    let(:line_item_2) { FactoryGirl.build(:line_item, product: product, option: option, cart: cart) }

    before do
      product.save
      product.line_items << line_item_1
      product.line_items << line_item_2
    end

    it 'should have two line_items' do
      expect(product.line_items.count).to eq 2
    end
    
    it 'should destroy associated line_items' do
      line_items = product.line_items.to_a
      product.destroy
      expect(line_items).not_to be_empty
      line_items.each do |line_item| 
        expect(Feature.where(id: line_item.id)).to be_empty
      end
    end
  end
end
