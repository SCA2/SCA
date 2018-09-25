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

  # describe 'bom associations' do
  #   it 'can create a bom' do
  #     product = create(:product)
  #     option = create(:option, product: product)
  #     expect{create(:bom, option: option)}.to change {Bom.count}.by(1)
  #   end

  #   it 'has one unique bom' do
  #     product = create(:product)
  #     option = create(:option, product: product)
  #     create(:bom, option: option)
  #     expect{create(:bom, option: option)}.to raise_error ActiveRecord::RecordInvalid
  #   end

  #   it 'should destroy associated bom' do
  #     product = create(:product)
  #     option = create(:option, product: product)
  #     create(:bom, option: option)
  #     expect {option.destroy}.to change {Bom.count}.by(-1)
  #   end

  #   it 'is not destroyed with associated bom' do
  #     product = create(:product)
  #     option = create(:option, product: product)
  #     bom = create(:bom, option: option)
  #     expect {bom.destroy}.not_to change {Option.count}
  #   end
  # end

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

  describe 'bom_lead_time' do
    it 'without lead time returns nil' do
      component = build(:component, lead_time: nil)
      expect(component.bom_lead_time).to eq(nil)
    end

    it 'without bom returns self.lead_time' do
      component = build(:component, lead_time: 15)
      expect(component.bom_lead_time).to eq(15)
    end

    it 'with bom returns bom.lead_time' do
      component = create(:component, stock: 1, lead_time: 1)
      assembly = create(:component, stock: 0, lead_time: 2)
      bom = create(:bom, component: assembly)
      create(:bom_item, bom: bom, component: component, quantity: 1)
      expect(assembly.bom_lead_time).to eq(1)
    end
  end

  describe 'bom_stock' do
    it 'with nil stock and no bom returns nil' do
      component = build(:component, stock: nil)
      expect(component.bom_stock).to eq(nil)
    end

    it 'without bom returns self.stock' do
      component = build(:component, stock: 1)
      expect(component.bom_stock).to eq(1)
    end

    it 'with bom and self.stock > 0 returns self.stock' do
      component = create(:component, stock: 1)
      assembly = create(:component, stock: 2)
      bom = create(:bom, component: assembly)
      bom_item = create(:bom_item, bom: bom, component: component)
      expect(assembly.bom_stock).to eq(2)
    end

    it 'with bom and self.stock == 0 returns bom stock' do
      component = create(:component, stock: 1)
      assembly = create(:component, stock: 0)
      bom = create(:bom, component: assembly)
      bom_item = create(:bom_item, bom: bom, component: component)
      expect(assembly.bom_stock).to eq(1)
    end

    it 'with bom and self.stock < 0 returns bom stock' do
      component = create(:component, stock: 1)
      assembly = create(:component, stock: -1)
      bom = create(:bom, component: assembly)
      bom_item = create(:bom_item, bom: bom, component: component)
      expect(assembly.bom_stock).to eq(1)
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
      bom_item = create(:bom_item, bom: bom, component: c_1)
      c_2 = create(:component, bom: bom, stock: -1)

      c_2.pick!(quantity: 1)

      expect(c_2.reload.bom_stock).to eq(-1)
      expect(c_1.reload.bom_stock).to eq(-1)
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

  describe 'restock' do
    it 'without bom adds to self.stock' do
      component = build(:component, stock: 0)
      component.restock(quantity: 1)
      expect(component.stock).to eq(1)
    end

    it 'with bom.stock >= quantity adds quantity to self.stock' do
      c_1 = create(:component, stock: 2)

      bom = create(:bom)
      bom_item = create(:bom_item, bom: bom, component: c_1, quantity: 2)
      c_2 = create(:component, bom: bom, stock: 0)

      c_2.restock!(quantity: 1)

      expect(c_2.reload.stock).to eq(1)
      expect(c_1.reload.stock).to eq(0)
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