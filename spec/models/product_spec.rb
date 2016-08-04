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
  it { should respond_to(:specifications) }

  it { should respond_to(:features) }
  it { should respond_to(:line_items) }
  it { should respond_to(:options) }
  it { should respond_to(:boms) }

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
    it 'can have multiple options' do
      product = create(:product)
      create(:option, product: product, sort_order: 10)
      create(:option, product: product, sort_order: 20)
      expect(product.options.count).to eq 2
    end

    it 'should have the options sorted by sort_order' do
      product = create(:product)
      option_1 = create(:option, product: product, sort_order: 10)
      option_2 = create(:option, product: product, sort_order: 20)
      expect(product.options.to_a).to eq [option_1, option_2]
    end
    
    it 'should destroy associated options' do
      product = create(:product)
      create(:option, product: product, sort_order: 10)
      create(:option, product: product, sort_order: 20)
      expect {product.destroy}.to change {Option.count}.by(-2)
    end

    it 'is not destroyed with associated option' do
      product = create(:product)
      option = create(:option, product: product, sort_order: 10)
      expect {option.destroy}.not_to change {Product.count}
    end
  end

  describe 'line_item associations' do
    it 'can have multiple line_items' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line_1 = create(:line_item, product: product, option: option, cart: cart)
      line_2 = create(:line_item, product: product, option: option, cart: cart)
      expect(product.line_items.count).to eq 2
    end

    it 'is not destroyed with associated line_item' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, product: product, option: option, cart: cart)
      expect {line.destroy}.not_to change {Product.count}
    end

    it 'line_item association does not constrain line_item destroy' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, product: product, option: option, cart: cart)
      expect {line.destroy}.to change {LineItem.count}.by(-1)
    end
    
    it 'line_item association constrains product destroy' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, product: product, option: option, cart: cart)
      expect {product.destroy}.to raise_error(ActiveRecord::InvalidForeignKey)
      expect(Product.count).to eq 1
    end

    it 'can be destroyed after associated line_item' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, product: product, option: option, cart: cart)
      line.destroy
      expect {product.destroy}.to change {Product.count}.by(-1)
    end
  end

  describe 'bom associations' do
    it 'can have multiple boms' do
      product = create(:product)
      create(:bom, product: product, revision: 1)
      create(:bom, product: product, revision: 2)
      expect(product.boms.count).to eq 2
    end

    it 'should return boms sorted by revision number' do
      product = create(:product)
      rev_2 = create(:bom, product: product, revision: 2)
      rev_1 = create(:bom, product: product, revision: 1)
      rev_3 = create(:bom, product: product, revision: 3)
      expect(product.boms.to_a).to eq [rev_1, rev_2, rev_3]
    end
    
    it 'should destroy associated boms' do
      product = create(:product)
      create(:bom, product: product, revision: 10)
      create(:bom, product: product, revision: 20)
      expect {product.destroy}.to change {Bom.count}.by(-2)
    end

    it 'is not destroyed with associated bom' do
      product = create(:product)
      bom = create(:bom, product: product, revision: 10)
      expect {bom.destroy}.not_to change {Product.count}
    end
  end

end
