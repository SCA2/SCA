class BomImporter

  require 'roo'

  include ActiveModel::Model

  attr_accessor :file

  FIRST_COMPONENT_ROW = 5

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'BomImporter')
  end

  def save
    if imported_bom.valid?
      imported_bom.save!
      true
    else
      imported_bom.bom_items.each_with_index do |item, index|
        item.errors.full_messages.each do |message|
          errors.add :base, "Line: #{index + FIRST_COMPONENT_ROW}, #{message}"
        end
      end
      false
    end
  end

  def imported_bom
    @imported_bom ||= load_imported_bom
  end

  def load_imported_bom
    spreadsheet = open_spreadsheet
    attributes = {}
    product = Product.find_by(model: spreadsheet.a2.strip)
    option = Option.find_by(product: product, model: spreadsheet.b2.strip)
    attributes[:option_id] = option.id
    attributes[:revision] = spreadsheet.c2.strip
    bom = Bom.find_by(option: option) || Bom.new
    bom.attributes = attributes
    header = spreadsheet.row(4)
    (FIRST_COMPONENT_ROW..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      next unless component = Component.find_by(mfr_part_number: row["mfr_part_number"])
      bom_item = bom.bom_items.find_by(component: component) || BomItem.new
      row["component_id"] = component.id
      row["bom_id"] = bom.id
      bom_item.attributes = row.to_hash.slice(*BomItem.permitted_attributes)
      bom.bom_items << bom_item
    end
    bom
  end

  def open_spreadsheet
    if File.extname(file.original_filename) == ".csv"
      Roo::CSV.new(file.path)
    else
      raise "Unsupported file type: #{file.original_filename}"
    end
  end
end