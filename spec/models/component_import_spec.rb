require 'rails_helper'
include ActionDispatch::TestProcess

describe ComponentImport do

  it { should respond_to(:imported_components) }
  it { should respond_to(:load_imported_components) }
  it { should respond_to(:open_spreadsheet) }

  it 'imports components from csv file' do
    importer = ComponentImport.new
    importer.file = fixture_file_upload('files/components.csv')
    expect(importer.imported_components.length).to eq 9
  end

  it 'imports components from ods file' do
    importer = ComponentImport.new
    importer.file = fixture_file_upload('files/components.ods')
    expect(importer.imported_components.length).to eq 9
  end

  it 'imports components from xlsx file' do
    importer = ComponentImport.new
    importer.file = fixture_file_upload('files/components.xlsx')
    expect(importer.imported_components.length).to eq 9
  end

  it 'does not import from xls file' do
    importer = ComponentImport.new
    importer.file = fixture_file_upload('files/components.xls')
    expect { importer.imported_components.length }.to raise_error(RuntimeError, "Unsupported file type: components.xls")
  end

  it 'imports from named sheet' do
    importer = ComponentImport.new
    importer.file = fixture_file_upload('files/boms.xlsx')
    importer.sheet_name = 'A12BR12_BOM'
    expect(importer.imported_components.length).to eq 5
  end

  it 'saves components' do
    importer = ComponentImport.new
    importer.file = fixture_file_upload('files/components.csv')
    importer.save
    expect(Component.count).to eq 9
  end

  it 'saves new components' do
    importer = ComponentImport.new
    importer.file = fixture_file_upload('files/components.csv')
    importer.save
    expect(Component.count).to eq 9
    importer.file = fixture_file_upload('files/new_components.csv')
    importer.save
    expect(Component.count).to eq 10
  end

  it 'updates existing components' do
    importer = ComponentImport.new
    importer.file = fixture_file_upload('files/components.csv')
    importer.save
    expect(Component.where(mfr_part_number: 'C315C471J1G5TA').take.stock).to eq 29
    importer.file = fixture_file_upload('files/duplicate_components.csv')
    importer.save
    expect(Component.where(mfr_part_number: 'C315C471J1G5TA').take.stock).to eq 30
  end
end