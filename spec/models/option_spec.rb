require 'rails_helper'

describe Option do

  let(:product) { FactoryGirl.create(:product) }
  before do
    @option = product.options.build(
							  model: 'A12KF',
							  description: 'Description',
							  price: 249,
							  upc: 123456789,
							  shipping_weight: 3,
                sort_order: 10,
                discount: 20,
                shipping_length: 8,
                shipping_width: 3,
                shipping_height: 2,
                assembled_stock: 8,
                partial_stock: 8)
							  component_stock: 100,
	end
  
  subject { @option }
  
  it { should be_valid }
  
  it { should respond_to(:product_id) }
  it { should respond_to(:model) }
  it { should respond_to(:description) }
  it { should respond_to(:price) }
  it { should respond_to(:upc) }
  it { should respond_to(:shipping_weight) }
  it { should respond_to(:sort_order) }
  it { should respond_to(:discount) }
  it { should respond_to(:shipping_length) }
  it { should respond_to(:shipping_width) }
  it { should respond_to(:shipping_height) }
  it { should respond_to(:assembled_stock) }
  it { should respond_to(:partial_stock) }
  it { should respond_to(:component_stock) }
  
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

  describe 'with no component_stock' do
    before { @option.component_stock = nil }
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

  it 'calculates shipping volume' do
		@option.shipping_length = 2
		@option.shipping_width = 2
		@option.shipping_height = 2
  	expect(@option.shipping_volume).to eq(8)
  end

  it 'recalculates stock' do
    @option.assembled_stock = 0
    @option.partial_stock = 0
		@option.component_stock = 100
		@option.subtract_stock(1)
  	expect(@option.component_stock).to eq(99)
  end

  # it 'sells an in-stock item' do
		# @option.assembled_stock = 8
		# @option.partial_stock = 8
		# @option.component_stock = 25
		# @option.sell(1)
  # 	expect(@option.assembled_stock).to eq(7)
  # 	expect(@option.partial_stock).to eq(8)
  # 	expect(@option.component_stock).to eq(25)
  # end

  # it 'sells an out-of-stock item' do
		# @option.assembled_stock = 1
		# @option.partial_stock = 1
		# @option.component_stock = 25
		# @option.sell(4)
  # 	expect(@option.assembled_stock).to eq(0)
  # 	expect(@option.partial_stock).to eq(0)
  # 	expect(@option.part_stock).to eq(23)
  # end
end
