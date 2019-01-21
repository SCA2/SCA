require 'rails_helper'

describe BomItem do

  it { should respond_to(:quantity) }
  it { should respond_to(:reference) }

  describe 'bom associations' do
    let(:bom) { create(:bom) }

    it 'belongs to a bom' do
      item = create(:bom_item, bom: bom)
      expect(item.bom).to eq(bom)
    end

    it 'should not destroy associated bom' do
      item = create(:bom_item, bom: bom)
      expect {item.destroy}.not_to change {Bom.count}
    end

    it 'is destroyed with associated bom' do
      item = create(:bom_item, bom: bom)
      expect {bom.destroy}.to change {BomItem.count}.by(-1)
    end
  end

  describe 'component associations' do
    let(:component) { create(:component) }

    it 'belongs to a component' do
      item = create(:bom_item, component: component)
      expect(item.component).to eq(component)
    end

    it 'prevents destruction of associated component' do
      item = create(:bom_item, component: component)
      expect {component.destroy}.to raise_exception(ActiveRecord::DeleteRestrictionError)
    end

    it 'does not destroy associated component' do
      item = create(:bom_item, component: component)
      expect {item.destroy}.not_to change {Component.count}
    end
  end

  describe 'stock' do
    it 'calculates stock' do
      component = create(:component, stock: 11)
      item = create(:bom_item, component: component, quantity: 2)
      expect(item.stock).to eq(5)
    end

    it 'returns 0 if component unstocked' do
      component = create(:component, stock: nil)
      item = create(:bom_item, component: component, quantity: 2)
      expect(item.stock).to eq(0)
    end
  end

  describe 'pick!' do
    it 'picks stock from component inventory' do
      component = create(:component, stock: 11)
      item = create(:bom_item, component: component, quantity: 3)
      expect { item.pick!(quantity: 2) }.to change { component.stock }.by(-6)
    end
  end

  describe 'restock!' do
    it 'restocks component inventory' do
      component = create(:component, stock: 11)
      item = create(:bom_item, component: component, quantity: 3)
      expect { item.restock!(quantity: 2) }.to change { component.stock }.by(6)
    end
  end
end