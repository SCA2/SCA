class BomCreator

  include ActiveModel::Model

  attr_reader :bom, :products, :components, :new_item
  attr_accessor :product, :component, :revision, :pdf, :quantity, :reference

  delegate :bom_items, :bom_items_attributes=, to: :bom, prefix: false
  
  validates :product, :revision, :pdf, presence: true

  def persisted?
    false
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'BomCreator')
  end

  def initialize(id = nil)
    if id
      @bom = Bom.find(id)
      @product = @bom.product
      @revision = @bom.revision
      @pdf = @bom.pdf
    else
      @bom = Bom.new
    end
    @products = Product.all
    @components = Component.all
    @new_item = BomItem.new
  end

  def parse_bom_items(params = nil)
    if bom_items_params = params[:bom_items_attributes]
      bom_items_params.each do |k, v|
        if v[:component] && v[:component].class == String
          v[:component] = Component.find(v[:component])
        end
      end
    end
  end

  def parse_product(params = nil)
    if params[:product] && params[:product].class == String
      @product = Product.find(params[:product])
      params[:product] = @product
    end
  end

  def set_attributes(params)
    return nil unless params
    @revision = params[:revision]
    @pdf = params[:pdf]
    parse_product(params)
    parse_bom_items(params)
  end

  def id
    @bom.id
  end

  def product_model
    @bom.product.model
  end

  def save(params)
    action(params) { |params| @bom = Bom.create(params) }
  end

  def update(params)
    action(params) { |params| @bom.update(params) }
  end

  def selected
    @selected = @bom.product ? @bom.product.id : 0
  end

private

  def action(params)
    set_attributes(params)
    if valid?
      yield params
      true
    else
      false
    end
  end

end