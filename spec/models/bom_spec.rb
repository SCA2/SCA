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
      bom = create(:bom)
      create(:bom_item, bom: bom, reference: 'R1')
      create(:bom_item, bom: bom, reference: 'R2')
      expect(bom.lines).to eq 2
    end

    # it 'can report stock' do
    #   bom = create(:bom)
    #   item_1 = double (:bom_item, bom: bom, reference: 1)
    #   item_2 = double (:bom_item, bom: bom, reference: 1)
    #   expect(bom.stock).to eq item_1.stock
    # end
  end

  describe 'bom_item associations' do
    it 'can have multiple bom_items' do
      bom = create(:bom)
      create(:bom_item, bom: bom, reference: 'R1')
      create(:bom_item, bom: bom, reference: 'R2')
      expect(bom.bom_items.count).to eq 2
    end

    it 'should return bom_items sorted by reference number' do
      bom = create(:bom)
      rev_2 = create(:bom_item, bom: bom, reference: 'R2')
      rev_1 = create(:bom_item, bom: bom, reference: 'R1')
      rev_3 = create(:bom_item, bom: bom, reference: 'R3')
      expect(bom.bom_items.to_a).to eq [rev_1, rev_2, rev_3]
    end
    
    it 'should destroy associated bom_items' do
      bom = create(:bom)
      create(:bom_item, bom: bom, reference: 'C1')
      create(:bom_item, bom: bom, reference: 'C2')
      expect {bom.destroy}.to change {BomItem.count}.by(-2)
    end

    it 'is not destroyed with associated bom_item' do
      bom = create(:bom)
      bom_item = create(:bom_item, bom: bom, reference: 'D1')
      expect {bom_item.destroy}.not_to change {Bom.count}
    end
  end
end