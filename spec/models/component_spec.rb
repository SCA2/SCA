require 'rails_helper'

describe Component do

  it { should respond_to(:value) }
  it { should respond_to(:marking) }
  it { should respond_to(:description) }
  it { should respond_to(:mfr) }
  it { should respond_to(:vendor) }
  it { should respond_to(:mfr_part_number) }
  it { should respond_to(:vendor_part_number) }
  it { should respond_to(:stock) }
  it { should respond_to(:lead_time) }

  describe 'bom_item associations' do
    it 'has many bom_items' do
      component = create(:component)
      bom1 = build_stubbed(:bom)
      bom2 = build_stubbed(:bom)
      create(:bom_item, bom: bom1, component: component)
      create(:bom_item, bom: bom2, component: component)
      expect(component.bom_items.count).to eq 2
    end

    it 'is unique within a bom' do
      component = create(:component)
      bom = build_stubbed(:bom)
      create(:bom_item, bom: bom, component: component)
      expect{create(:bom_item, bom: bom, component: component)}.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'does not destroy associated bom_items' do
      component = create(:component)
      bom = build_stubbed(:bom)
      create(:bom_item, bom: bom, component: component)
      expect {component.destroy}.to raise_exception(ActiveRecord::DeleteRestrictionError)
    end

    it 'is not destroyed with associated bom_item' do
      component = create(:component)
      bom = build_stubbed(:bom)
      bom_item = create(:bom_item, bom: bom, component: component)
      expect {bom_item.destroy}.not_to change {Component.count}
    end
  end

  describe 'selection name' do
    it 'returns a name for a select list' do
      component = create(:component, mfr_part_number: 'mfr', value: 'value', description: 'description')
      expect(component.selection_name).to eq 'mfr, value, description'
    end

    it 'handles missing value' do
      component = create(:component, mfr_part_number: 'mfr', value: nil, description: 'description')
      expect(component.selection_name).to eq 'mfr, description'
    end

    it 'handles missing value and description' do
      component = create(:component, mfr_part_number: 'mfr', value: nil, description: '')
      expect(component.selection_name).to eq 'mfr'
    end
  end
end