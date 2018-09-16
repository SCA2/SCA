namespace :db do
  desc "Convert product options to options, components, and tags"
  task convert_options: :environment do
    options = Option.all
    options.each do |option|
      mfr_part_number = option.product.model + option.model
      next if Component.exists?(mfr_part_number: mfr_part_number)
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
        upc: option[:upc],
        full_price: option[:price],
        discount_price: option[:discount],
        shipping_length: option[:shipping_length],
        shipping_width: option[:shipping_width],
        shipping_height: option[:shipping_height],
        shipping_weight: option[:shipping_weight]
      )
      option.update!(component_id: component.id)
      bom = Bom.find_by(option_id: option.id)
      bom.update!(component_id: component.id) if bom
    end
  end
end