require 'rails_helper'

describe InventoryCalculator do
  describe 'inventory' do
    let(:product) { create(:product) }
    let(:option) { build(:option, product: product) }

    let(:kf_2s) { build(:option, product: product) }
    let(:kf_2h) { build(:option, product: product) }

    let(:c_1) { build(:component, stock: 10) }
    let(:c_2) { build(:component, stock: 10) }
    let(:c_3) { build(:component, stock: 10) }

    # make a kit:
    # subtract components common to all product options from component inventory
    # add kit to kit inventory

    it 'makes kits' do
      allow(kf_2s).to receive(:is_kit?) { true }
      allow(kf_2h).to receive(:is_kit?) { true }

      kf_2s.kit_stock = 0
      kf_2h.kit_stock = 0

      create(:bom, option: kf_2s)
      create(:bom_item, bom: kf_2s.bom, component: c_1, quantity: 1)
      create(:bom_item, bom: kf_2s.bom, component: c_2, quantity: 1)

      create(:bom, option: kf_2h)
      create(:bom_item, bom: kf_2h.bom, component: c_1, quantity: 1)
      create(:bom_item, bom: kf_2h.bom, component: c_3, quantity: 1)

      item_2s = build(:line_item, itemizable: kf_2s, quantity: 1)
      item_2h = build(:line_item, itemizable: kf_2h, quantity: 1)

      InventoryCalculator.new(item: item_2h).make_kits
      InventoryCalculator.new(item: item_2s).make_kits

      # reserve common parts for each kit
      expect(kf_2s.common_stock).to eq(8)
      expect(kf_2h.common_stock).to eq(8)
      
      # option stock not subtracted until sold
      expect(kf_2s.option_stock).to eq(10)
      expect(kf_2h.option_stock).to eq(10)

      # kits are the same until sold
      expect(kf_2s.kit_stock).to eq(2)
      expect(kf_2h.kit_stock).to eq(2)
    end

    it 'sells a component' do
      item = build(:line_item, itemizable: c_1, quantity: 2)
      ic = InventoryCalculator.new(item: item)
      expect { ic.sell_components }.to change { c_1.stock }.by(-item.quantity)
    end

    # sell a kit:
    # subtract components unique to product kf_2s from component inventory
    # subtract kit from kit inventory

    it 'sells an in-stock kit' do
      allow(kf_2s).to receive(:is_kit?) { true }
      allow(kf_2h).to receive(:is_kit?) { true }

      kf_2s.assembled_stock = 8
      kf_2s.partial_stock = 8
      kf_2s.kit_stock = 8

      create(:bom, option: kf_2s)
      create(:bom_item, bom: kf_2s.bom, component: c_1, quantity: 1)
      create(:bom_item, bom: kf_2s.bom, component: c_2, quantity: 1)

      create(:bom, option: kf_2h)
      create(:bom_item, bom: kf_2h.bom, component: c_1, quantity: 1)
      create(:bom_item, bom: kf_2h.bom, component: c_3, quantity: 1)

      item_2s = build(:line_item, itemizable: kf_2s, quantity: 1)

      InventoryCalculator.new(item: item_2s).sell_kits

      expect(kf_2s.assembled_stock).to eq(8)
      expect(kf_2s.partial_stock).to eq(8)
      expect(kf_2s.kit_stock).to eq(7)
      expect(kf_2s.common_stock).to eq(10)
    end

    it 'sells an out-of-stock kit' do
      allow(option).to receive(:is_kit?) {true}
      option.assembled_stock = 1
      option.partial_stock = 1
      option.kit_stock = 1
      bom = create(:bom, option: option)
      cmp_1 = create(:component, stock: 25)
      cmp_2 = create(:component, stock: 50)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)

      item = build(:line_item, itemizable: option, quantity: 2)
      
      InventoryCalculator.new(item: item).sell_kits

      expect(option.assembled_stock).to eq(1)
      expect(option.partial_stock).to eq(1)
      expect(option.kit_stock).to eq(0)
      expect(option.common_stock).to eq(24)
    end

    # prepare partial:
    # subtract components common to all product options from component inventory
    # add partial to partial inventory

    it 'makes partials' do
      allow(option).to receive(:is_assembled?) {true}
      option.partial_stock = 0
      bom = create(:bom, option: option)
      cmp_1 = create(:component, stock: 100)
      cmp_2 = create(:component, stock: 200)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)

      item = build(:line_item, itemizable: option, quantity: 1)

      InventoryCalculator.new(item: item).make_partials

      expect(option.common_stock).to eq(99)
      expect(option.partial_stock).to eq(1)
    end

    # prepare assembly for sale:
    # subtract components unique to product option from component inventory
    # assemble components and partial into complete assembly
    # add assembly to assembled inventory

    it 'assembles partials and option components into assembly' do
      allow(option).to receive(:is_assembled?) {true}
      option.assembled_stock = 0
      option.partial_stock = 1
      option.kit_stock = 0
      bom = create(:bom, option: option)
      cmp_1 = create(:component, stock: 100)
      cmp_2 = create(:component, stock: 200)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)

      item = build(:line_item, itemizable: option, quantity: 1)

      InventoryCalculator.new(item: item).make_assemblies

      expect(option.partial_stock).to eq(0)
      expect(option.assembled_stock).to eq(1)
    end

    it 'recalculates assembled stock' do
      option.model = 'KA'
      option.assembled_stock = 0
      option.partial_stock = 0
      option.kit_stock = 0
      bom = create(:bom, option: option)
      cmp_1 = create(:component, stock: 100)
      cmp_2 = create(:component, stock: 200)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)

      item = build(:line_item, itemizable: option, quantity: 1)

      InventoryCalculator.new(item: item).subtract_stock

      expect(option.common_stock).to eq(99)
    end

    # sell an assembly:
    # subtract assembly from assembled inventory

    it 'sells an in-stock module' do
      option.model = 'KA'
      option.assembled_stock = 8
      option.partial_stock = 8
      option.kit_stock = 8
      bom = create(:bom, option: option)
      cmp_1 = create(:component, stock: 25)
      cmp_2 = create(:component, stock: 50)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)

      item = build(:line_item, itemizable: option, quantity: 1)

      InventoryCalculator.new(item: item).subtract_stock

      expect(option.assembled_stock).to eq(7)
      expect(option.partial_stock).to eq(8)
      expect(option.kit_stock).to eq(8)
      expect(option.common_stock).to eq(25)
    end

    it 'sells an out-of-stock module' do
      option.model = 'KA'
      option.assembled_stock = 1
      option.partial_stock = 1
      option.kit_stock = 1
      bom = create(:bom, option: option)
      cmp_1 = create(:component, stock: 25)
      cmp_2 = create(:component, stock: 50)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)

      item = build(:line_item, itemizable: option, quantity: 4)

      InventoryCalculator.new(item: item).subtract_stock

      expect(option.assembled_stock).to eq(0)
      expect(option.partial_stock).to eq(0)
      expect(option.kit_stock).to eq(1)
      expect(option.common_stock).to eq(23)
    end    

    it 'subtracts from components and adds to kits' do
      product = create(:product)
      option = create(:option, product: product) 
      bom = create(:bom, option: option)

      option.model = 'KF'
      option.kit_stock = 1
      option.partial_stock = 0
      option.assembled_stock = 0

      cmp_1 = create(:component, stock: 10)
      cmp_2 = create(:component, stock: 20)
      create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
      create(:bom_item, bom: bom, component: cmp_2, quantity: 2)

      item = build(:line_item, itemizable: option, quantity: 2)

      InventoryCalculator.new(item: item).make_kits

      expect(product.common_stock).to eq(8)
      expect(product.kit_stock).to eq(3)
      expect(product.partial_stock).to eq(0)
      expect(option.assembled_stock).to eq(0)
    end

    # it 'subtracts from components and adds to partial assemblies' do
    #   product = create(:product, kit_stock: 0, partial_stock: 1)
    #   option = create(:option, model: 'KA', product: product, assembled_stock: 0)
    #   bom = create(:bom, option: option)
    #   cmp_1 = create(:component, stock: 100)
    #   cmp_2 = create(:component, stock: 200)
    #   create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
    #   create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
    #   attributes = attributes_for(:option_editor, product: product, option: option)
    #   attributes[:option_editor][:model] = 'KA'
    #   attributes[:option_editor][:kit_stock] = product.kit_stock
    #   attributes[:option_editor][:partial_stock] = product.partial_stock
    #   attributes[:option_editor][:assembled_stock] = option.assembled_stock
    #   attributes[:option_editor][:partials_to_make] = 5
    #   editor = build(:option_editor, attributes)
    #   editor.save
    #   product.reload
    #   option.reload
    #   expect(product.kit_stock).to eq(0)
    #   expect(product.partial_stock).to eq(6)
    #   expect(option.assembled_stock).to eq(0)
    # end

    # it 'subtracts from partials and adds to complete assemblies' do
    #   product = create(:product, kit_stock: 3, partial_stock: 3)
    #   option = create(:option, model: 'KA', product: product, assembled_stock: 0) 
    #   bom = create(:bom, option: option)
    #   cmp_1 = create(:component, stock: 100)
    #   cmp_2 = create(:component, stock: 200)
    #   create(:bom_item, bom: bom, component: cmp_1, quantity: 1)
    #   create(:bom_item, bom: bom, component: cmp_2, quantity: 2)
    #   attributes = attributes_for(:option_editor, product: product, option: option)
    #   attributes[:option_editor][:model] = 'KA'
    #   attributes[:option_editor][:kit_stock] = product.kit_stock
    #   attributes[:option_editor][:partial_stock] = product.partial_stock
    #   attributes[:option_editor][:assembled_stock] = option.assembled_stock
    #   attributes[:option_editor][:assembled_to_make] = 2
    #   create(:option_editor, attributes)
    #   product.reload
    #   option.reload
    #   expect(product.kit_stock).to eq(3)
    #   expect(product.partial_stock).to eq(1)
    #   expect(option.assembled_stock).to eq(2)
    # end
  end
end