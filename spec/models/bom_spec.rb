require 'rails_helper'

describe Bom do
  it { should respond_to(:product) }
  it { should respond_to(:revision) }
  it { should respond_to(:pdf) }  
  it { should respond_to(:bom_items) }  

  describe 'bom_item associations' do
    it 'can have multiple bom_items' do
      bom = create(:bom)
      create(:bom_item, bom: bom, reference: 1)
      create(:bom_item, bom: bom, reference: 2)
      expect(bom.bom_items.count).to eq 2
    end

    it 'should return bom_items sorted by reference number' do
      bom = create(:bom)
      rev_2 = create(:bom_item, bom: bom, reference: 2)
      rev_1 = create(:bom_item, bom: bom, reference: 1)
      rev_3 = create(:bom_item, bom: bom, reference: 3)
      expect(bom.bom_items.to_a).to eq [rev_1, rev_2, rev_3]
    end
    
    it 'should destroy associated bom_items' do
      bom = create(:bom)
      create(:bom_item, bom: bom, reference: 1)
      create(:bom_item, bom: bom, reference: 2)
      expect {bom.destroy}.to change {BomItem.count}.by(-2)
    end

    it 'is not destroyed with associated bom_item' do
      bom = create(:bom)
      bom_item = create(:bom_item, bom: bom, reference: 1)
      expect {bom_item.destroy}.not_to change {Bom.count}
    end
  end
end