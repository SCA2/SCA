namespace :db do
  desc "Convert product options to options, components, and tags"
  task convert_options: :environment do
    options = Option.all
    options.each_with_index do |option, i|
      if Component.exists?(mfr_part_number: option.item_model)
        mfr_part_number = option.item_model + i.to_s
      else
        mfr_part_number = option.item_model
      end
      component = Component.create!(
        description: option.description,
        mfr: 'SCA',
        vendor: 'SCA',
        mfr_part_number: mfr_part_number,
        stock: option.assembled_stock,
        lead_time: 7
      )
      SizeWeightPriceTag.create!(
        component_id: component.id,
        upc: option.upc,
        full_price: option.price,
        discount_price: option.discount,
        shipping_length: option.shipping_length,
        shipping_width: option.shipping_width,
        shipping_height: option.shipping_height,
        shipping_weight: option.shipping_weight
      )
      option.update!(component_id: component.id)
      option.bom.update!(component_id: component.id) if option.bom
    end
  end
end