require 'rails_helper'

describe SizeWeightPriceTag do

  let(:tag) { build(:size_weight_price_tag) }
  
  subject { tag }
  
  it { should be_valid }
  
  it { should respond_to(:component) }
  it { should respond_to(:upc) }
  it { should respond_to(:full_price) }
  it { should respond_to(:full_price_in_cents) }
  it { should respond_to(:discount_price) }
  it { should respond_to(:discount_price_in_cents) }
  it { should respond_to(:shipping_length) }
  it { should respond_to(:shipping_width) }
  it { should respond_to(:shipping_height) }
  it { should respond_to(:shipping_weight) }

  describe 'shipping attributes' do
    it 'complains if shipping_length not an integer' do
      editor = build(:size_weight_price_tag, shipping_length: 1.5)
      expect(editor).to have(1).errors_on(:shipping_length)
    end

    it 'complains if shipping_length too small' do
      editor = build(:size_weight_price_tag, shipping_length: -1)
      expect(editor).to have(1).errors_on(:shipping_length)
    end

    it 'complains if shipping_length too large' do
      editor = build(:size_weight_price_tag, shipping_length: 25)
      expect(editor).to have(1).errors_on(:shipping_length)
    end

    it 'complains if shipping_width not an integer' do
      editor = build(:size_weight_price_tag, shipping_width: 1.5)
      expect(editor).to have(1).errors_on(:shipping_width)
    end

    it 'complains if shipping_width too small' do
      editor = build(:size_weight_price_tag, shipping_width: -1)
      expect(editor).to have(1).errors_on(:shipping_width)
    end

    it 'complains if shipping_width too large' do
      editor = build(:size_weight_price_tag, shipping_width: 13)
      expect(editor).to have(1).errors_on(:shipping_width)
    end

    it 'complains if shipping_height not an integer' do
      editor = build(:size_weight_price_tag, shipping_height: 1.5)
      expect(editor).to have(1).errors_on(:shipping_height)
    end

    it 'complains if shipping_height too small' do
      editor = build(:size_weight_price_tag, shipping_height: -1)
      expect(editor).to have(1).errors_on(:shipping_height)
    end

    it 'complains if shipping_height too large' do
      editor = build(:size_weight_price_tag, shipping_height: 7)
      expect(editor).to have(1).errors_on(:shipping_height)
    end

    it 'complains if shipping_weight not an integer' do
      editor = build(:size_weight_price_tag, shipping_weight: 1.5)
      expect(editor).to have(1).errors_on(:shipping_weight)
    end

    it 'complains if shipping_weight too small' do
      editor = build(:size_weight_price_tag, shipping_weight: -1)
      expect(editor).to have(1).errors_on(:shipping_weight)
    end

    it 'complains if shipping_weight too large' do
      editor = build(:size_weight_price_tag, shipping_weight: 31)
      expect(editor).to have(1).errors_on(:shipping_weight)
    end
  end

  describe 'component associations' do
    it 'is destroyed with associated component' do
      component = create(:component)
      create(:size_weight_price_tag, component: component)
      expect { component.destroy }.to change { SizeWeightPriceTag.count }.by(-1)
    end
    
    it 'does not destroy associated component when destroyed' do
      component = create(:component)
      tag = create(:size_weight_price_tag, component: component)
      expect { tag.destroy }.not_to change { Component.count }
    end
  end

  describe 'line item associations' do
    it 'can belong to multiple line_items through component' do
      component = create(:component)
      tag = create(:size_weight_price_tag, component: component)
      create(:line_item, itemizable: component)
      create(:line_item, itemizable: component)
      expect(tag.line_items.count).to eq 2
    end
    
    it 'is not deleted with associated line_item' do
      component = create(:component)
      tag = create(:size_weight_price_tag, component: component)
      line_item = create(:line_item, itemizable: component)
      expect { line_item.destroy }.not_to change { SizeWeightPriceTag.count }
    end
    
    it 'tag association does not constrain line_item destroy' do
      component = create(:component)
      tag = create(:size_weight_price_tag, component: component)
      line_item = create(:line_item, itemizable: component)
      expect { line_item.destroy }.to change { LineItem.count }.by(-1)
    end

    it 'line_item association constrains tag destroy' do
      component = create(:component)
      tag = create(:size_weight_price_tag, component: component)
      create(:line_item, itemizable: component)
      count = SizeWeightPriceTag.count
      expect { tag.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
      expect(SizeWeightPriceTag.count).to eq(count)
    end
  end

  describe 'product option associations' do
    it 'can belong to multiple options through component' do
      component = create(:component)
      tag = create(:size_weight_price_tag, component: component)
      create(:option, component: component)
      create(:option, component: component)
      expect(tag.options.count).to eq 2
    end
    
    it 'is not deleted with associated option' do
      component = create(:component)
      tag = create(:size_weight_price_tag, component: component)
      option = create(:option, component: component)
      expect { option.destroy }.not_to change { SizeWeightPriceTag.count }
    end
    
    it 'tag association does not constrain option destroy' do
      component = create(:component)
      tag = create(:size_weight_price_tag, component: component)
      option = create(:option, component: component)
      expect { option.destroy }.to change { Option.count }.by(-1)
    end

    it 'option association constrains tag destroy' do
      component = create(:component)
      tag = create(:size_weight_price_tag, component: component)
      create(:option, component: component)
      count = SizeWeightPriceTag.count
      expect { tag.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
      expect(SizeWeightPriceTag.count).to eq(count)
    end
  end

  describe 'calculations' do  
    it 'calculates price_in_cents' do
      tag.full_price = 1
      expect(tag.full_price_in_cents).to eq(100)
    end

    it 'calculates discount_in_cents' do
      tag.discount_price = 1
      expect(tag.discount_price_in_cents).to eq(100)
    end
  end
end
