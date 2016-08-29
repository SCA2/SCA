require 'rails_helper'

describe Bom do
  it { should respond_to(:product) }
  it { should respond_to(:revision) }
  it { should respond_to(:pdf) }  
  it { should respond_to(:bom_items) }  
  it { should respond_to(:lines) }  
  it { should respond_to(:stock) }  

  describe 'bom_item methods' do
    it 'can report number of bom_items' do
      bom = build_stubbed(:bom)
      create(:bom_item, bom: bom, reference: 'R1')
      create(:bom_item, bom: bom, reference: 'R2')
      expect(bom.lines).to eq 2
    end

    it 'can report stock' do
      option = build_stubbed(:option)
      bom = create(:bom, option: option)
      cmp_1 = create(:component, stock: 5)
      cmp_2 = create(:component, stock: 6)
      cmp_3 = create(:component, stock: 7)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_3, quantity: 2)
      expect(bom.stock).to eq 3
    end

    it 'can subtract stock' do
      option = build_stubbed(:option)
      bom = create(:bom, option: option)
      cmp_1 = create(:component, stock: 5)
      cmp_2 = create(:component, stock: 6)
      cmp_3 = create(:component, stock: 7)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_3, quantity: 2)
      bom.subtract_stock(2)
      expect(bom.stock).to eq 1
      expect(cmp_1.reload.stock).to eq 3
      expect(cmp_2.reload.stock).to eq 4
      expect(cmp_3.reload.stock).to eq 3
    end

    it 'can add stock' do
      option = build_stubbed(:option)
      bom = create(:bom, option: option)
      cmp_1 = create(:component, stock: 5)
      cmp_2 = create(:component, stock: 6)
      cmp_3 = create(:component, stock: 7)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_3, quantity: 2)
      bom.add_stock(2)
      expect(bom.stock).to eq 5
      expect(cmp_1.reload.stock).to eq 7
      expect(cmp_2.reload.stock).to eq 8
      expect(cmp_3.reload.stock).to eq 11
    end
  end

  describe 'bom_item associations' do
    it 'can have multiple bom_items' do
      bom = build_stubbed(:bom)
      create(:bom_item, bom: bom, reference: 'R1')
      create(:bom_item, bom: bom, reference: 'R2')
      expect(bom.bom_items.count).to eq 2
    end

    it 'should return bom_items sorted by reference number' do
      bom = build_stubbed(:bom)
      rev_2 = create(:bom_item, bom: bom, reference: 'R2')
      rev_1 = create(:bom_item, bom: bom, reference: 'R1')
      rev_3 = create(:bom_item, bom: bom, reference: 'R3')
      expect(bom.bom_items.to_a).to eq [rev_1, rev_2, rev_3]
    end
    
    it 'should destroy associated bom_items' do
      product = build_stubbed(:product)
      option = build_stubbed(:option, product: product)
      bom = create(:bom, option: option)
      create(:bom_item, bom: bom, reference: 'C1')
      create(:bom_item, bom: bom, reference: 'C2')
      expect {bom.destroy}.to change {BomItem.count}.by(-2)
    end

    it 'is not destroyed with associated bom_item' do
      bom = build_stubbed(:bom)
      bom_item = create(:bom_item, bom: bom, reference: 'D1')
      expect {bom_item.destroy}.not_to change {Bom.count}
    end
  end
end