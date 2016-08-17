class BomCreator

  include ActiveModel::Model

  attr_reader :products, :components
  attr_accessor :bom, :new_item

  delegate :bom_items, :bom_items_attributes=, to: :bom, prefix: false
  delegate :product, :revision, :pdf, to: :bom, prefix: false
  delegate :quantity, :reference, :component, to: :bom_item, prefix: false

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
      k = (bom_items_params.length - 1).to_s
      v = bom_items_params[k]
      quantity = v[:quantity]
      reference = v[:reference]
      component = v[:component]
    end
  end

  def parse_product(params = nil)
    if params[:product] && params[:product].class == String
      @bom.product = Product.find(params[:product])
      params[:product] = bom.product
    end
  end

  def set_attributes(params)
    return nil unless params
    @bom.revision = params[:revision]
    @bom.pdf = params[:pdf]
    parse_product(params)
    parse_bom_items(params)
  end

  def get_errors
    if @bom.errors.any?
      @bom.errors.full_messages.each { |e| errors[:base] << e }
      false
    else
      true
    end
  end

  def save(params)
    set_attributes(params)
    if valid?
      @bom.save
      get_errors
    else
      false
    end
  end

  def update(params)
    set_attributes(params)
    if valid?
      @bom.update(params)
      get_errors
    else
      false
    end
  end

  def selected
    @selected = @bom.product ? @bom.product.id : 0
  end

  def id
    @bom.id
  end

  def product_model
    @bom.product.model
  end
  
end
