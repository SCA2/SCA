require 'rails_helper'

describe Product do

  let(:product) { build(:product) }
  let(:cart) { build_stubbed(:cart) }
  let(:option) { build_stubbed(:option) }

  subject { product }

  it { should be_valid }

  it { should respond_to(:active) }
  it { should respond_to(:model) }
  it { should respond_to(:short_description) }
  it { should respond_to(:long_description) }
  it { should respond_to(:image_1) }
  it { should respond_to(:image_2) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
  it { should respond_to(:model_sort_order) }
  it { should respond_to(:notes) }
  it { should respond_to(:bom) }
  it { should respond_to(:schematic) }
  it { should respond_to(:assembly) }
  it { should respond_to(:specifications) }
  it { should respond_to(:partial_stock) }
  it { should respond_to(:kit_stock) }

  it { should respond_to(:features) }
  it { should respond_to(:options) }

  it "is invalid without a model" do
    expect(Product.new(model: nil)).to have(1).errors_on(:model)
  end

  it "is invalid without a model_sort_order" do
    expect(Product.new(model_sort_order: nil)).to have(2).errors_on(:model_sort_order)
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

  describe 'feature associations' do

    let(:first_feature) { create(:feature, sort_order: 10) }
    let(:last_feature)  { create(:feature, sort_order: 100) }

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
      create(:option, product: product, model: 'a', sort_order: 10)
      create(:option, product: product, model: 'b', sort_order: 20)
      expect(product.options.count).to eq 2
    end

    it 'should have the options sorted by sort_order' do
      product = create(:product)
      option_1 = create(:option, product: product, model: 'a', sort_order: 10)
      option_2 = create(:option, product: product, model: 'b', sort_order: 20)
      expect(product.options.to_a).to eq [option_1, option_2]
    end
    
    it 'should destroy associated options' do
      product = create(:product)
      create(:option, product: product, model: 'a', sort_order: 10)
      create(:option, product: product, model: 'b', sort_order: 20)
      expect {product.destroy}.to change {Option.count}.by(-2)
    end

    it 'is not destroyed with associated option' do
      product = create(:product)
      option = create(:option, product: product, sort_order: 10)
      expect {option.destroy}.not_to change {Product.count}
    end
  end

  describe 'line_item associations' do
    it 'is not destroyed with associated line_item' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, option: option, cart: cart)
      expect {line.destroy}.not_to change {Product.count}
    end

    it 'line_item association does not constrain line_item destroy' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, option: option, cart: cart)
      expect {line.destroy}.to change {LineItem.count}.by(-1)
    end
    
    it 'line_item association constrains product destroy' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, option: option, cart: cart)
      expect {product.destroy}.to raise_error(ActiveRecord::InvalidForeignKey)
      expect(Product.count).to eq 1
    end

    it 'can be destroyed after associated line_item' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, option: option, cart: cart)
      line.destroy
      expect {product.destroy}.to change {Product.count}.by(-1)
    end
  end

  describe 'inventory' do

    let(:prod_1) { create(:product) }
    let(:op_1) { build(:option, product: prod_1) }
    let(:op_2) { build(:option, product: prod_1) }

    let(:prod_2) { create(:product) }
    let(:op_3) { build(:option, product: prod_2) }
    let(:op_4) { build(:option, product: prod_2) }

    let(:c_1) { build(:component, stock: 6) }
    let(:c_2) { build(:component, stock: 6) }
    let(:c_3) { build(:component, stock: 6) }

    # common_stock = components common to all product options / quantity
    # option_stock = components unique to this option / quantity
    # limiting_stock = minimum of common_stock and option_stock

    it 'reports correct common stock' do
      allow(op_1).to receive(:is_kit?) {true}
      allow(op_2).to receive(:is_kit?) {true}

      op_1.kit_stock = 0

      create(:bom, option: op_1)
      create(:bom_item, bom: op_1.bom, component: c_1, quantity: 2)
      create(:bom_item, bom: op_1.bom, component: c_2, quantity: 1)

      create(:bom, option: op_2)
      create(:bom_item, bom: op_2.bom, component: c_1, quantity: 3)
      create(:bom_item, bom: op_2.bom, component: c_3, quantity: 1)

      create(:bom, option: op_3)
      create(:bom_item, bom: op_3.bom, component: c_3, quantity: 1)

      # byebug

      expect(op_1.common_stock).to eq(2)
      expect(op_2.common_stock).to eq(2)
      expect(op_3.common_stock).to eq(6)
    end
  end
end
