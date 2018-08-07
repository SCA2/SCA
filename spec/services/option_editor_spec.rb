require 'rails_helper'

describe OptionEditor do

  let!(:product) { create(:product) }
  let!(:option) { create(:option, product: product) }
  let!(:bom) { create(:bom, option: option) }
  let!(:bom_item) { create(:bom_item, bom: bom)}

  describe 'associations' do
    it 'has correct product' do
      editor = create(:option_editor, product: product, option: option)
      expect(editor.product).to eq product
    end
    
    it 'has correct option' do
      editor = create(:option_editor, product: product, option: option)
      expect(editor.option).to eq option
    end
    
    it 'has correct bom' do
      editor = create(:option_editor, product: product, option: option)
      expect(editor.bom).to eq bom
    end
  end
  
  describe 'shipping' do
    it 'complains if shipping_length not an integer' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_length] = 1.5
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_length)
    end

    it 'complains if shipping_length too small' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_length] = -1
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_length)
    end

    it 'complains if shipping_length too large' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_length] = 25
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_length)
    end

    it 'complains if shipping_width not an integer' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_width] = 1.5
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_width)
    end

    it 'complains if shipping_width too small' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_width] = -1
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_width)
    end

    it 'complains if shipping_width too large' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_width] = 13
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_width)
    end

    it 'complains if shipping_height not an integer' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_height] = 1.5
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_height)
    end

    it 'complains if shipping_height too small' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_height] = -1
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_height)
    end

    it 'complains if shipping_height too large' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_height] = 7
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_height)
    end

    it 'complains if shipping_weight not an integer' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_weight] = 1.5
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_weight)
    end

    it 'complains if shipping_weight too small' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_weight] = -1
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_weight)
    end

    it 'complains if shipping_weight too large' do
      attributes = attributes_for(:option_editor, product: product, option: option)
      attributes[:option_editor][:shipping_weight] = 31
      editor = create(:option_editor, attributes)
      expect(editor).to have(1).errors_on(:shipping_weight)
    end
  end
end