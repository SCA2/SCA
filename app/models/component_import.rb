class ComponentImport

  require 'roo'

  include ActiveModel::Model

  attr_reader :file
  attr_accessor :sheet_name

  def file=(file)
    @file = file
    @imported_components = nil
  end

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
    spreadsheet.default_sheet = select_sheet(spreadsheet)
    header = normalize_header(spreadsheet.row(1))
    temp = Component.new
    (FIRST_COMPONENT_ROW..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      temp.attributes = row.to_hash.slice(*Component.permitted_attributes)
      component = Component.find_by(mfr_part_number: temp.mfr_part_number)
      if component
        id = component.id
        component.attributes = temp.attributes
        component.id = id
      else
        component = Component.new(temp.attributes)
      end
      component
    end
  end

  def open_spreadsheet
    if File.extname(file.original_filename) == ".csv"
      Roo::CSV.new(file.path)
    elsif File.extname(file.original_filename) == ".xlsx"
      Roo::Spreadsheet.open(file.path, extension: :xlsx)
    elsif File.extname(file.original_filename) == ".ods"
      Roo::Spreadsheet.open(file.path, extension: :ods)
    else
      raise "Unsupported file type: #{file.original_filename}"
    end
  end

  def select_sheet(spreadsheet)
    sheets = spreadsheet.sheets.select { |s| /#{sheet_name}/.match(s) }
    sheets ? sheets.first : spreadsheet.sheets.first
  end

  def normalize_header(header)
    header.map do |h|
      name = h.to_s.downcase.gsub(/ /, '_')
      name = 'mfr' if name == 'manufacturer'
      name
    end
  end
end