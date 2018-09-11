class BomCreator

  include ActiveModel::Model

  delegate :bom_items, :bom_items_attributes=, to: :bom
  delegate :quantity, :reference, to: :bom_item

  attr_reader :components, :bom, :items

  def model_name
    ActiveModel::Name.new(self, nil, 'BomCreator')
  end

  def initialize(id = nil)
    @components = Component.all
    if id
      @bom = Bom.find(id)
      @root_component = @bom.component
    else
      @bom = Bom.new
      @root_component = @components.first
    end
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

  def new_item
    if @bom.errors.any?
      items = bom_items
    else
      items = bom_items.build
    end
  end

  def parse_component(params = nil)
    if params[:root_component] && params[:root_component].class == String
      @bom.component = Component.find(params[:root_component])
      @root_component = @bom.component
    end
  end

  def set_attributes(params)
    return nil unless params
    parse_component(params)
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

  def root_component
    @root_component ? @root_component.id : 0
  end

  def selected_component(index)
    component(index) ? component(index).id : 0
  end

  def quantity(index)
    q = item(index) ? item(index).quantity : 0
    q ? q : 0
  end

  def reference(index)
    item(index) ? item(index).reference : ''
  end

  def stock(index)
    s = component(index) ? component(index).stock : 0
    s ? s : 0
  end

  def lead_time(index)
    l = component(index) ? component(index).lead_time : 0
    l ? l : 0
  end

  def component(index)
    item(index).component
  end

  def item(index)
    @bom.bom_items[index]
  end

  def id
    @bom.id
  end

  def bom_name
    @root_component.mfr_part_number
  end
  
end
