require 'rails_helper'

describe Option do

  let(:product) { create(:product) }
  let(:option) { build(:option, product: product) }
  
  subject { option }
  
  it { should be_valid }
  
  it { should respond_to(:product_id) }
  it { should respond_to(:model) }
  it { should respond_to(:description) }
  it { should respond_to(:price) }
  it { should respond_to(:price_in_cents) }
  it { should respond_to(:upc) }
  it { should respond_to(:shipping_weight) }
  it { should respond_to(:sort_order) }
  it { should respond_to(:discount) }
  it { should respond_to(:discount_in_cents) }
  it { should respond_to(:shipping_length) }
  it { should respond_to(:shipping_width) }
  it { should respond_to(:shipping_height) }
  it { should respond_to(:assembled_stock) }
  it { should respond_to(:active) }
  it { should respond_to(:active?) }
  it { should respond_to(:bom) }

  it { expect(option.product).to eql product }

  it 'reports its active status' do
    option.active = false
    expect(option.active?).to be false
    option.active = true
    expect(option.active?).to be true
  end

  describe 'product associations' do
    it 'is destroyed with associated product' do
      product = create(:product)
      create(:option, product: product)
      expect {product.destroy}.to change {Option.count}.by(-1)
    end
    
    it 'does not destroy associated product when destroyed' do
      product = create(:product)
      option = create(:option, product: product)
      expect {option.destroy}.not_to change {Product.count}
    end
  end

  describe 'line item associations' do
    it 'can have multiple line_items' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      create(:line_item, cart: cart, product: product, option: option)
      create(:line_item, cart: cart, product: product, option: option)
      expect(option.line_items.count).to eq 2
    end
    
    it 'is not deleted with associated line_item' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, cart: cart, product: product, option: option)
      expect {line.destroy}.not_to change {Option.count}
    end
    
    it 'line_item association does not constrain line_item destroy' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, cart: cart, product: product, option: option)
      expect {line.destroy}.to change {LineItem.count}.by(-1)
    end

    it 'line_item association constrains option destroy' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      create(:line_item, cart: cart, product: product, option: option)
      expect {option.destroy}.to raise_error(ActiveRecord::InvalidForeignKey)
      expect(Option.count).to eq 1
    end
  
    it 'can be deleted after associated line_item' do
      cart = create(:cart)
      product = create(:product)
      option = create(:option, product: product)
      line = create(:line_item, cart: cart, product: product, option: option)
      line.destroy
      expect {option.destroy}.to change {Option.count}.by(-1)
    end
  end

  describe 'bom associations' do
    it 'can create a bom' do
      product = create(:product)
      option = create(:option, product: product)
      expect{create(:bom, option: option)}.to change {Bom.count}.by(1)
    end

    it 'has one unique bom' do
      product = create(:product)
      option = create(:option, product: product)
      create(:bom, option: option)
      expect{create(:bom, option: option)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'should destroy associated bom' do
      product = create(:product)
      option = create(:option, product: product)
      create(:bom, option: option)
      expect {option.destroy}.to change {Bom.count}.by(-1)
    end

    it 'is not destroyed with associated bom' do
      product = create(:product)
      option = create(:option, product: product)
      bom = create(:bom, option: option)
      expect {bom.destroy}.not_to change {Option.count}
    end
  end

  describe 'calculations' do  
    it 'calculates price_in_cents' do
      option.price = 1
      expect(option.price_in_cents).to eq(100)
    end

    it 'calculates discount_in_cents' do
      option.discount = 1
      expect(option.discount_in_cents).to eq(100)
    end

    it 'calculates shipping volume' do
      option.shipping_length = 2
      option.shipping_width = 2
      option.shipping_height = 2
      expect(option.shipping_volume).to eq(8)
    end
  end

  describe 'option type' do

    it 'self-identifies as kit' do
      option.model = 'KF-2S'
      expect(option.is_kit?).to be true
      expect(option.is_assembled?).to be false
    end

    it 'self-identifies as assembled' do
      option.model = 'KA-2H'
      expect(option.is_kit?).to be false
      expect(option.is_assembled?).to be true
    end
  end  

  describe 'inventory' do

    let(:prod_1) { create(:product) }
    let(:prod_2) { create(:product) }

    let(:op_1) { build(:option, product: prod_1) }
    let(:op_2) { build(:option, product: prod_1) }
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
      allow(op_3).to receive(:is_assembled?) {true}

      op_1.kit_stock = 0

      create(:bom, option: op_1)
      create(:bom_item, bom: op_1.bom, component: c_1, quantity: 2)
      create(:bom_item, bom: op_1.bom, component: c_2, quantity: 1)

      create(:bom, option: op_3)
      create(:bom_item, bom: op_3.bom, component: c_1, quantity: 3)
      create(:bom_item, bom: op_3.bom, component: c_3, quantity: 1)

      expect(op_1.common_stock).to eq(3)
      expect(op_3.common_stock).to eq(2)
    end

    it 'reports correct option stock for single option' do
      allow(op_1).to receive(:is_kit?) {true}

      op_1.kit_stock = 0

      create(:bom, option: op_1)
      create(:bom_item, bom: op_1.bom, component: c_1, quantity: 2)
      create(:bom_item, bom: op_1.bom, component: c_2, quantity: 1)

      expect(op_1.option_stock).to eq(3)
    end

    it 'reports correct common and option stock for multiple options' do
      allow(op_1).to receive(:is_kit?) {true}
      allow(op_2).to receive(:is_kit?) {true}

      op_1.kit_stock = 0
      op_2.kit_stock = 0

      create(:bom, option: op_1)
      create(:bom_item, bom: op_1.bom, component: c_1, quantity: 1)
      create(:bom_item, bom: op_1.bom, component: c_2, quantity: 2)

      create(:bom, option: op_2)
      create(:bom_item, bom: op_2.bom, component: c_1, quantity: 1)
      create(:bom_item, bom: op_2.bom, component: c_3, quantity: 3)

      expect(op_1.common_stock).to eq(6)
      expect(op_2.common_stock).to eq(6)
      expect(op_1.option_stock).to eq(3)
      expect(op_2.option_stock).to eq(2)
    end
  end
end
