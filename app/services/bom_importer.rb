class BomImporter

  require 'roo'

  include ActiveModel::Model

  attr_accessor :file

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
    if imported_boms.map(&:valid?).all?
      imported_boms.each(&:save!)
      true
    else
      imported_boms.each_with_index do |bom, index|
        bom.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_boms
    @imported_boms ||= load_imported_boms
  end

  def load_imported_boms
    spreadsheet = open_spreadsheet
    attributes = {}
    product = Product.find_by(model: spreadsheet.a2)
    option = Option.find_by(product: product, model: spreadsheet.b2)
    attributes[:option_id] = option.id
    attributes[:revision] = spreadsheet.c2
    attributes[:pdf] = spreadsheet.d2
    bom = Bom.find_by(option: option) || Bom.new
    bom.attributes = attributes
    header = spreadsheet.row(4)
    (5..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      next unless component = Component.find_by(mfr_part_number: row["mfr_part_number"])
      bom_item = bom.bom_items.find_by(component: component) || BomItem.new
      row["component_id"] = component.id
      row["bom_id"] = bom.id
      bom_item.attributes = row.to_hash.slice(*BomItem.permitted_attributes)
      bom.bom_items << bom_item
      bom
    end
  end

  def open_spreadsheet
    if File.extname(file.original_filename) == ".csv"
      Roo::CSV.new(file.path)
    else
      raise "Unsupported file type: #{file.original_filename}"
    end
  end
end