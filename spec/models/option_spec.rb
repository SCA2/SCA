require 'rails_helper'

describe Option do

  let(:product) { create(:product) }
  before do
    @option = product.options.build(
							  model: 'A12KF',
                active: true,
							  description: 'Description',
                upc: 123456789,
                sort_order: 10,
							  price: 249,
                discount: 20,
                shipping_length: 8,
                shipping_width: 3,
                shipping_height: 2,
							  shipping_weight: 3,
                assembled_stock: 8,
                partial_stock: 8,
							  kit_stock: 8)
	end
  
  subject { @option }
  
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
  it { should respond_to(:partial_stock) }
  it { should respond_to(:kit_stock) }
  it { should respond_to(:active) }
  it { should respond_to(:active?) }
  it { should respond_to(:bom) }

  it { expect(@option.product).to eql product }

  describe 'when product_id is not present' do
    before { @option.product_id = nil }
    it { should_not be_valid }
  end
  
  describe 'with no model' do
    before { @option.model = nil }
    it { should_not be_valid }
  end

  describe 'with no description' do
    before { @option.description = nil }
    it { should_not be_valid }
  end

  describe 'with no active flag' do
    before { @option.active = nil }
    it { should_not be_valid }
  end

  describe 'with no price' do
    before { @option.price = nil }
    it { should_not be_valid }
  end

  describe 'with no upc' do
    before { @option.upc = nil }
    it { should_not be_valid }
  end

  describe 'with no shipping weight' do
    before { @option.shipping_weight = nil }
    it { should_not be_valid }
  end

  describe 'with no sort_order' do
    before { @option.sort_order = nil }
    it { should_not be_valid }
  end

  describe 'with no discount' do
    before { @option.discount = nil }
    it { should_not be_valid }
  end

  describe 'with no shipping_length' do
    before { @option.shipping_length = nil }
    it { should_not be_valid }
  end

  describe 'with no shipping_width' do
    before { @option.shipping_width = nil }
    it { should_not be_valid }
  end

  describe 'with no shipping_height' do
    before { @option.shipping_height = nil }
    it { should_not be_valid }
  end

  describe 'with no assembled_stock' do
    before { @option.assembled_stock = nil }
    it { should_not be_valid }
  end

  describe 'with no partial_stock' do
    before { @option.partial_stock = nil }
    it { should_not be_valid }
  end

  describe 'with no kit_stock' do
    before { @option.kit_stock = nil }
    it { should_not be_valid }
  end

  it 'complains if shipping_length not an integer' do
    @option.shipping_length = 0.5
    expect(@option).to have(1).errors_on(:shipping_length)
  end

  it 'complains if shipping_length too small' do
    @option.shipping_length = 0
    expect(@option).to have(1).errors_on(:shipping_length)
  end

  it 'complains if shipping_length too large' do
    @option.shipping_length = 25
    expect(@option).to have(1).errors_on(:shipping_length)
  end

  it 'complains if shipping_width not an integer' do
    @option.shipping_width = 0.5
    expect(@option).to have(1).errors_on(:shipping_width)
  end

  it 'complains if shipping_width too small' do
    @option.shipping_width = 0
    expect(@option).to have(1).errors_on(:shipping_width)
  end

  it 'complains if shipping_width too large' do
    @option.shipping_width = 13
    expect(@option).to have(1).errors_on(:shipping_width)
  end

  it 'complains if shipping_height not an integer' do
    @option.shipping_height = 0.5
    expect(@option).to have(1).errors_on(:shipping_height)
  end

  it 'complains if shipping_height too small' do
    @option.shipping_height = 0
    expect(@option).to have(1).errors_on(:shipping_height)
  end

  it 'complains if shipping_height too large' do
    @option.shipping_height = 7
    expect(@option).to have(1).errors_on(:shipping_height)
  end

  it 'reports its active status' do
    @option.active = false
    expect(@option.active?).to be false
    @option.active = true
    expect(@option.active?).to be true
  end

  describe 'product associations' do
    it 'product association does not constrain product delete' do
      product = create(:product)
      option = create(:option, product: product)
      expect {product.destroy}.to change {Product.count}.by(-1)
    end
    
    it 'is destroyed with associated product' do
      product = create(:product)
      option = create(:option, product: product)
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
      @option.price = 1
      expect(@option.price_in_cents).to eq(100)
    end

    it 'calculates discount_in_cents' do
      @option.discount = 1
      expect(@option.discount_in_cents).to eq(100)
    end

    it 'calculates shipping volume' do
      @option.shipping_length = 2
      @option.shipping_width = 2
      @option.shipping_height = 2
      expect(@option.shipping_volume).to eq(8)
    end

    it 'subtracts from components and adds to kits' do
      @option.assembled_stock = 0
      @option.partial_stock = 0
      @option.kit_stock = 1
      bom = create(:bom, option: @option)
      cmp_1 = create(:component, stock: 100)
      cmp_2 = create(:component, stock: 200)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
      @option.make_kits(2)
      expect(@option.component_stock).to eq(98)
      expect(@option.kit_stock).to eq(3)
      expect(@option.partial_stock).to eq(0)
      expect(@option.assembled_stock).to eq(0)
    end

    it 'subtracts from kits and adds to partial assemblies' do
      @option.assembled_stock = 0
      @option.partial_stock = 1
      @option.kit_stock = 3
      @option.make_partials(2)
      expect(@option.kit_stock).to eq(1)
      expect(@option.partial_stock).to eq(3)
      expect(@option.assembled_stock).to eq(0)
    end

    it 'subtracts from partials and adds to complete assemblies' do
      @option.assembled_stock = 0
      @option.partial_stock = 2
      @option.kit_stock = 3
      @option.make_completes(2)
      expect(@option.kit_stock).to eq(3)
      expect(@option.partial_stock).to eq(0)
      expect(@option.assembled_stock).to eq(2)
    end

    it 'recalculates kit stock' do
      @option.assembled_stock = 0
      @option.partial_stock = 0
      @option.kit_stock = 0
      bom = create(:bom, option: @option)
      cmp_1 = create(:component, stock: 100)
      cmp_2 = create(:component, stock: 200)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
      @option.subtract_stock(1)
      expect(@option.component_stock).to eq(99)
    end

    it 'recalculates assembled stock' do
      @option.model = 'KA'
      @option.assembled_stock = 0
      @option.partial_stock = 0
      @option.kit_stock = 0
      bom = create(:bom, option: @option)
      cmp_1 = create(:component, stock: 100)
      cmp_2 = create(:component, stock: 200)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
      @option.subtract_stock(1)
      expect(@option.component_stock).to eq(99)
    end

    it 'sells an in-stock kit' do
      @option.assembled_stock = 8
      @option.partial_stock = 8
      @option.kit_stock = 8
      bom = create(:bom, option: @option)
      cmp_1 = create(:component, stock: 25)
      cmp_2 = create(:component, stock: 50)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
      @option.subtract_stock(1)
      expect(@option.assembled_stock).to eq(8)
      expect(@option.partial_stock).to eq(8)
      expect(@option.kit_stock).to eq(7)
      expect(@option.component_stock).to eq(25)
    end

    it 'sells an out-of-stock kit' do
      @option.assembled_stock = 1
      @option.partial_stock = 1
      @option.kit_stock = 1
      bom = create(:bom, option: @option)
      cmp_1 = create(:component, stock: 25)
      cmp_2 = create(:component, stock: 50)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
      @option.subtract_stock(2)
      expect(@option.assembled_stock).to eq(1)
      expect(@option.partial_stock).to eq(1)
      expect(@option.kit_stock).to eq(0)
      expect(@option.component_stock).to eq(24)
    end

    it 'sells an in-stock module' do
      @option.model = 'KA'
      @option.assembled_stock = 8
      @option.partial_stock = 8
      @option.kit_stock = 8
      bom = create(:bom, option: @option)
      cmp_1 = create(:component, stock: 25)
      cmp_2 = create(:component, stock: 50)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
      @option.subtract_stock(1)
      expect(@option.assembled_stock).to eq(7)
      expect(@option.partial_stock).to eq(8)
      expect(@option.kit_stock).to eq(8)
      expect(@option.component_stock).to eq(25)
    end

    it 'sells an out-of-stock module' do
      @option.model = 'KA'
      @option.assembled_stock = 1
      @option.partial_stock = 1
      @option.kit_stock = 1
      bom = create(:bom, option: @option)
      cmp_1 = create(:component, stock: 25)
      cmp_2 = create(:component, stock: 50)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
      @option.subtract_stock(4)
      expect(@option.assembled_stock).to eq(0)
      expect(@option.partial_stock).to eq(0)
      expect(@option.kit_stock).to eq(0)
      expect(@option.component_stock).to eq(24)
    end
  end
end
