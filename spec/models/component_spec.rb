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
      create(:bom_item, component: component, reference: 'C1')
      create(:bom_item, component: component, reference: 'C2')
      expect(component.bom_items.count).to eq 2
    end

    it 'does not destroy associated bom_items' do
      component = create(:component)
      create(:bom_item, component: component, reference: 'L1')
      create(:bom_item, component: component, reference: 'L2')
      expect {component.destroy}.to raise_exception(ActiveRecord::DeleteRestrictionError)
    end

    it 'is not destroyed with associated bom_item' do
      component = create(:component)
      bom_item = create(:bom_item, component: component, reference: 'U1')
      expect {bom_item.destroy}.not_to change {Component.count}
    end
  end

end