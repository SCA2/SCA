require 'rails_helper'

describe OptionEditor do

  let!(:product) { create(:product) }
  let!(:option) { create(:option, product: product) }
  let!(:bom) { create(:bom, option: option) }
  let!(:bom_item) { create(:bom_item, bom: bom)}

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
  
  it 'complains if shipping_length not an integer' do
    attributes = attributes_for(:option_editor, product: product, option: option)
    attributes[:option_editor][:shipping_length] = 0.5
    editor = create(:option_editor, attributes)
    expect(editor).to have(1).errors_on(:shipping_length)
  end

  it 'complains if shipping_length too small' do
    attributes = attributes_for(:option_editor, product: product, option: option)
    attributes[:option_editor][:shipping_length] = 0
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
    attributes[:option_editor][:shipping_width] = 0.5
    editor = create(:option_editor, attributes)
    expect(editor).to have(1).errors_on(:shipping_width)
  end

  it 'complains if shipping_width too small' do
    attributes = attributes_for(:option_editor, product: product, option: option)
    attributes[:option_editor][:shipping_width] = 0
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
    attributes[:option_editor][:shipping_height] = 0.5
    editor = create(:option_editor, attributes)
    expect(editor).to have(1).errors_on(:shipping_height)
  end

  it 'complains if shipping_height too small' do
    attributes = attributes_for(:option_editor, product: product, option: option)
    attributes[:option_editor][:shipping_height] = 0
    editor = create(:option_editor, attributes)
    expect(editor).to have(1).errors_on(:shipping_height)
  end

  it 'complains if shipping_height too large' do
    attributes = attributes_for(:option_editor, product: product, option: option)
    attributes[:option_editor][:shipping_height] = 7
    editor = create(:option_editor, attributes)
    expect(editor).to have(1).errors_on(:shipping_height)
  end

  it 'subtracts from components and adds to kits' do
    product = create(:product)
    option = create(:option, model: 'KF', product: product) 
    bom = create(:bom, option: option)
    cmp_1 = create(:component, stock: 100)
    cmp_2 = create(:component, stock: 200)
    create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
    create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
    # byebug
    attributes = attributes_for(:option_editor, product: product, option: option)
    attributes[:option_editor][:model] = 'KF'
    attributes[:option_editor][:kit_stock] = 1
    attributes[:option_editor][:partial_stock] = 0
    attributes[:option_editor][:assembled_stock] = 0
    attributes[:option_editor][:kits_to_make] = 2
    editor = create(:option_editor, attributes)
    product.reload
    option.reload
    expect(product.common_stock_count).to eq(98)
    expect(product.kit_stock).to eq(3)
    expect(product.partial_stock).to eq(0)
    expect(option.assembled_stock).to eq(0)
  end

  it 'subtracts from components and adds to partial assemblies' do
    product = create(:product, kit_stock: 0, partial_stock: 1)
    option = create(:option, model: 'KA', product: product, assembled_stock: 0)
    bom = create(:bom, option: option)
    cmp_1 = create(:component, stock: 100)
    cmp_2 = create(:component, stock: 200)
    create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
    create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
    attributes = attributes_for(:option_editor, product: product, option: option)
    attributes[:option_editor][:model] = 'KA'
    attributes[:option_editor][:kit_stock] = product.kit_stock
    attributes[:option_editor][:partial_stock] = product.partial_stock
    attributes[:option_editor][:assembled_stock] = option.assembled_stock
    attributes[:option_editor][:partials_to_make] = 5
    editor = build(:option_editor, attributes)
    editor.save
    product.reload
    option.reload
    # expect(product.common_stock_count).to eq(95)
    expect(product.kit_stock).to eq(0)
    expect(product.partial_stock).to eq(6)
    expect(option.assembled_stock).to eq(0)
  end

  it 'subtracts from partials and adds to complete assemblies' do
    product = create(:product, kit_stock: 3, partial_stock: 3)
    option = create(:option, model: 'KA', product: product, assembled_stock: 0) 
    bom = create(:bom, option: option)
    cmp_1 = create(:component, stock: 100)
    cmp_2 = create(:component, stock: 200)
    create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
    create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
    attributes = attributes_for(:option_editor, product: product, option: option)
    attributes[:option_editor][:model] = 'KA'
    attributes[:option_editor][:kit_stock] = product.kit_stock
    attributes[:option_editor][:partial_stock] = product.partial_stock
    attributes[:option_editor][:assembled_stock] = option.assembled_stock
    attributes[:option_editor][:assembled_to_make] = 2
    editor = create(:option_editor, attributes)
    product.reload
    option.reload
    expect(product.kit_stock).to eq(3)
    expect(product.partial_stock).to eq(1)
    expect(option.assembled_stock).to eq(2)
  end
end