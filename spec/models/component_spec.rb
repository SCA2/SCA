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

  describe 'bom associations' do
    let(:component) { create(:component) }

    it 'can create a bom' do
      expect{create(:bom, component: component)}.to change {Bom.count}.by(1)
    end

    it 'has one unique bom' do
      create(:bom, component: component)
      expect{create(:bom, component: component)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'should destroy associated bom' do
      create(:bom, component: component)
      expect {component.destroy}.to change {Bom.count}.by(-1)
    end

    it 'is not destroyed with associated bom' do
      bom = create(:bom, component: component)
      expect {bom.destroy}.not_to change {Component.count}
    end
  end

  describe 'bom_item associations' do
    it 'has many bom_items' do
      component = create(:component)
      bom1 = create(:bom)
      bom2 = create(:bom)
      create(:bom_item, bom: bom1, component: component)
      create(:bom_item, bom: bom2, component: component)
      expect(component.bom_items.count).to eq 2
    end

    it 'is unique within a bom' do
      component = create(:component)
      bom = create(:bom)
      create(:bom_item, bom: bom, component: component)
      expect{create(:bom_item, bom: bom, component: component)}.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'does not destroy associated bom_items' do
      component = create(:component)
      bom = create(:bom)
      create(:bom_item, bom: bom, component: component)
      expect {component.destroy}.to raise_exception(ActiveRecord::DeleteRestrictionError)
    end

    it 'is not destroyed with associated bom_item' do
      component = create(:component)
      bom = create(:bom)
      bom_item = create(:bom_item, bom: bom, component: component)
      expect {bom_item.destroy}.not_to change {Component.count}
    end
  end

  describe 'recursive_stock' do
    it 'if unstocked returns 0' do
      component = build(:component, stock: nil)
      expect(component.recursive_stock).to eq(0)
    end

    it 'without bom returns self[:stock]' do
      component = build(:component, stock: 1)
      expect(component.recursive_stock).to eq(1)
    end

    it 'with bom and self.stock > 0 returns self.stock' do
      component = create(:component, stock: 1)
      assembly = create(:component, stock: 2)
      bom = create(:bom, component: assembly)
      bom_item = create(:bom_item, bom: bom, component: component)
      expect(assembly.recursive_stock).to eq(2)
    end

    it 'with bom and self.stock == 0 returns bom stock' do
      component = create(:component, stock: 1)
      assembly = create(:component, stock: 0)
      bom = create(:bom, component: assembly)
      bom_item = create(:bom_item, bom: bom, quantity: 1, component: component)
      expect(assembly.recursive_stock).to eq(1)
    end

    it 'with bom and self.stock < 0 returns bom stock' do
      component = create(:component, stock: 1)
      assembly = create(:component, stock: -1)
      bom = create(:bom, component: assembly)
      bom_item = create(:bom_item, bom: bom, component: component)
      expect(assembly.recursive_stock).to eq(1)
    end
  end

  describe 'recursive_stock with subassemblies' do
    it 'reports correct stock with no intermediate stock' do
      c1 = create(:component, stock: 2)
      c2 = create(:component, stock: 2)
      c3 = create(:component, stock: 4)
      c4 = create(:component, stock: 8)
      sub1 = create(:component, stock: 0)
      sub2 = create(:component, stock: 0)
      bom1 = create(:bom, component: sub1)
      create(:bom_item, bom: bom1, component: c1, quantity: 1)
      create(:bom_item, bom: bom1, component: c2, quantity: 1)
      bom2 = create(:bom, component: sub2)
      create(:bom_item, bom: bom2, component: c3, quantity: 1)
      create(:bom_item, bom: bom2, component: c4, quantity: 2)
      assembly = create(:component, stock: 0)
      bom3 = create(:bom, component: assembly)
      create(:bom_item, bom: bom3, component: sub1, quantity: 1)
      create(:bom_item, bom: bom3, component: sub2, quantity: 2)
      expect(assembly.recursive_stock).to eq(2)
    end

    it 'reports correct stock with intermediate stock' do
      c1 = create(:component, stock: 2)
      c2 = create(:component, stock: 2)
      c3 = create(:component, stock: 1)
      c4 = create(:component, stock: 2)
      sub1 = create(:component, stock: 0)
      sub2 = create(:component, stock: 4)
      bom1 = create(:bom, component: sub1)
      create(:bom_item, bom: bom1, component: c1, quantity: 1)
      create(:bom_item, bom: bom1, component: c2, quantity: 1)
      bom2 = create(:bom, component: sub2)
      create(:bom_item, bom: bom2, component: c3, quantity: 1)
      create(:bom_item, bom: bom2, component: c4, quantity: 2)
      assembly = create(:component, stock: 0)
      bom3 = create(:bom, component: assembly)
      create(:bom_item, bom: bom3, component: sub1, quantity: 1)
      create(:bom_item, bom: bom3, component: sub2, quantity: 2)
      expect(assembly.recursive_stock).to eq(2)
    end
  end

  describe 'bom_lead_time' do
    it 'without lead time returns nil' do
      component = build(:component, lead_time: nil)
      expect(component.bom_lead_time).to eq(nil)
    end

    it 'without bom returns self.lead_time' do
      component = build(:component, stock: 0, lead_time: 15)
      expect(component.bom_lead_time).to eq(15)
    end

    it 'with bom returns bom.lead_time' do
      component = create(:component, stock: 0, lead_time: 1)
      assembly = create(:component, stock: 0, lead_time: 2)
      bom = create(:bom, component: assembly)
      create(:bom_item, bom: bom, component: component, quantity: 1)
      expect(assembly.bom_lead_time).to eq(1)
    end
  end

  describe 'pick' do
    it 'without bom subtracts quantity from self.stock' do
      component = build(:component, stock: 0)
      component.pick(quantity: 2)
      expect(component.stock).to eq(-2)
    end

    it 'with bom and self.stock == 0 subtracts quantity from bom stock' do
      c_1 = create(:component, stock: 1)

      bom = create(:bom)
      bom_item = create(:bom_item, bom: bom, component: c_1)
      c_2 = create(:component, bom: bom, stock: 0)

      c_2.pick!(quantity: 1)

      expect(c_2.reload.stock).to eq(0)
      expect(c_1.reload.stock).to eq(0)
    end

    it 'with bom and self.stock < 0 subtracts quantity from bom stock' do
      c_1 = create(:component, stock: 1)

      bom = create(:bom)
      bom_item = create(:bom_item, bom: bom, quantity: 1, component: c_1)
      c_2 = create(:component, bom: bom, stock: -1)

      c_2.pick!(quantity: 1)

      expect(c_2.reload.local_stock).to eq(0)
      expect(c_1.reload.local_stock).to eq(-1)
    end

    it 'cascades through boms' do
      c_1 = create(:component, stock: 2)
      asm_1 = create(:component, stock: 0)
      asm_2 = create(:component, stock: 0)
      asm_3 = create(:component, stock: 0)

      bom_1 = create(:bom, component: asm_1)
      create(:bom_item, bom: bom_1, component: c_1, quantity: 1)

      bom_2 = create(:bom, component: asm_2)
      create(:bom_item, bom: bom_2, component: asm_1, quantity: 1)

      bom_3 = create(:bom, component: asm_3)
      create(:bom_item, bom: bom_3, component: asm_2, quantity: 1)
      create(:bom_item, bom: bom_3, component: c_1, quantity: 1)

      expect(asm_3.bom_stock).to eq(2)
      expect(asm_2.bom_stock).to eq(2)
      expect(asm_1.bom_stock).to eq(2)
      expect(c_1.stock).to eq(2)

      asm_3.pick!(quantity: 1)

      expect(asm_3.reload.bom_stock).to eq(0)
      expect(asm_2.reload.bom_stock).to eq(0)
      expect(asm_1.reload.bom_stock).to eq(0)
      expect(c_1.reload.stock).to eq(0)
    end
  end

  describe 'make_assemblies' do
    it 'without bom stock does not change' do
      component = create(:component)
      expect{ component.make_assemblies!(quantity: 1) }.to_not change{ component.stock }
    end

    it 'with quantity <= bom.stock adds quantity to self.stock' do
      bom = create(:bom)
      c1 = create(:component, stock: 2)
      create(:bom_item, bom: bom, component: c1, quantity: 2)
      c2 = create(:component, bom: bom, stock: 0)

      c2.make_assemblies!(quantity: 1)

      expect(c2.reload.stock).to eq(1)
      expect(c1.reload.stock).to eq(0)
    end

    it 'with quantity > bom.stock adds bom.stock to self.stock' do
      bom = create(:bom)
      c1 = create(:component, stock: 2)
      create(:bom_item, bom: bom, component: c1, quantity: 2)
      c2 = create(:component, bom: bom, stock: 0)

      expect(c2.bom_stock).to eq(1)

      c2.make_assemblies!(quantity: 3)

      expect(c2.reload.stock).to eq(1)
      expect(c1.reload.stock).to eq(0)
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

  describe 'child_items' do
    it 'collects all descendant bom items' do
      asm_1 = create(:component)
      asm_2 = create(:component)
      asm_3 = create(:component)

      bom_1 = create(:bom, component: asm_1)
      create(:bom_item, bom: bom_1)
      create(:bom_item, bom: bom_1)

      bom_2 = create(:bom, component: asm_2)
      create(:bom_item, bom: bom_2)
      create(:bom_item, bom: bom_2)

      bom_3 = create(:bom, component: asm_3)
      create(:bom_item, bom: bom_3, component: asm_1)
      create(:bom_item, bom: bom_3, component: asm_2)

      expect(asm_3.child_items.count).to eq(6)
    end
  end
end