class BomImporter

  require 'roo'

  include ActiveModel::Model

  attr_accessor :product, :option, :file, :url
  attr_reader :products, :options, :bom

  FIRST_COMPONENT_ROW = 2

  def initialize(attributes = {})
    @imported_components = nil
    @imported_bom_items = nil
    @spreadsheet = nil
    @products = Product.joins(options: :bom).distinct.order(:sort_order)
    return unless @products.present?
    if attributes.empty?
      @bom = Bom.new
      @product = @products.first
      @option = product.options.first
    else
      attributes.each { |name, value| send("#{name}=", value) }
      @product = Product.find(attributes[:product])
      @option = Option.find(attributes[:option])
      @bom = @option.bom
      @spreadsheet = open_spreadsheet
      @spreadsheet.default_sheet = select_sheet(@spreadsheet)
    end
    @options = @product.options.joins(:bom).order(:sort_order)
  end

  def persisted?
    false
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'BomImporter')
  end

  def save
    if imported_components.map(&:invalid?).any?
      imported_components.each_with_index do |component, index|
        component.errors.full_messages.each do |message|
          errors.add :base, "Item #{index + FIRST_COMPONENT_ROW - 1}: #{message}"
        end
      end
      return false
    end

    Component.transaction do
      begin
        imported_components.each_with_index do |component, index|
          component.save!
        end
      rescue => e
        component.errors.full_messages.each do |message|
          errors.add :base, "Item #{index + FIRST_COMPONENT_ROW - 1}: #{message}"
        end
        return false
      end
    end

    @bom.bom_items << imported_bom_items
    if imported_bom_items.map(&:valid?).all?
      imported_bom_items.each(&:save!)
    else
      imported_bom_items.each_with_index do |item, index|
        item.errors.full_messages.each do |message|
          errors.add :base, "Item #{index + FIRST_COMPONENT_ROW - 1}:, #{message}"
        end
      end
      return false
    end
    true
  end

  def imported_components
    @imported_components ||= import_components_from_spreadsheet
  end

  def import_components_from_spreadsheet
    header = normalize_header(@spreadsheet.row(1))
    (FIRST_COMPONENT_ROW..@spreadsheet.last_row).map do |i|
      row = Hash[[header, @spreadsheet.row(i)].transpose]
      create_or_update_component(row)
    end
  end

  def create_or_update_component(row)
    attributes = row.to_hash.slice(*Component.permitted_attributes)
    component = Component.find_by(mfr_part_number: attributes[:mfr_part_number.to_s])
    if component
      id = component.id
      component.attributes = attributes
      component.id = id
    else
      component = Component.new(attributes)
    end
    component
  end

  def imported_bom_items
    @imported_bom_items ||= import_bom_items_from_spreadsheet
  end

  def import_bom_items_from_spreadsheet
    header = normalize_header(@spreadsheet.row(1))
    (FIRST_COMPONENT_ROW..@spreadsheet.last_row).map do |i|
      row = Hash[[header, @spreadsheet.row(i)].transpose]
      component = create_or_update_component(row)
      row["component_id"] = component.id
      row["bom_id"] = bom.id
      bom_item = @bom.bom_items.find_by(component: component) || BomItem.new
      bom_item.attributes = row.to_hash.slice(*BomItem.permitted_attributes)
      bom_item
    end
  end

  def open_spreadsheet
    if File.extname(file.original_filename) == ".xlsx"
      Roo::Spreadsheet.open(file.path, extension: :xlsx)
    else
      raise "Unsupported file type: #{file.original_filename}"
    end
  end

  def select_sheet(spreadsheet)
    sheets = spreadsheet.sheets.select { |s| /#{@product.model}\d*_BOM/.match(s) }
    sheets.empty? ? spreadsheet.sheets.first : sheets.first
  end

  def normalize_header(header)
    header.map do |h|
      name = h.to_s.strip.downcase.gsub(/ /, '_')
      name = 'mfr' if name.include?('manufacturer')
      name = 'quantity' if name.include?('qty')
      name = 'reference' if name.include?('ref')
      name = 'mfr_part_number' if name.include?("man's_number")
      name = 'vendor' if name.include?('source')
      name
    end
  end

end