class ComponentImport

  require 'roo'

  include ActiveModel::Model

  attr_accessor :file

  FIRST_COMPONENT_ROW = 2

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'ComponentImport')
  end

  def save
    if imported_components.map(&:valid?).all?
      imported_components.each(&:save!)
      true
    else
      imported_components.each_with_index do |component, index|
        component.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_components
    @imported_components ||= load_imported_components
  end

  def load_imported_components
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    temp = Component.new
    (FIRST_COMPONENT_ROW..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      temp.attributes = row.to_hash.slice(*Component.permitted_attributes)
      component = Component.find_by(mfr_part_number: row['mfr_part_number']) || Component.new
      stock = component.stock ? component.stock + temp.stock : temp.stock
      component.attributes = temp.attributes
      component.stock = stock
      component.vendor_part_number = component.mfr_part_number unless component.vendor_part_number
      component.lead_time = 0 unless component.lead_time
      component
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