require 'faker'

FactoryBot.define do
  factory :option_editor, class: 'OptionEditor' do
    transient do
      product nil
      option nil
    end

    product_id { product.model }
    id { option.id }

    #form attributes
    option_editor {{
      model: 'KF-2S',
      description: 'option description',
      upc: '123456789012',
      price: 329,
      discount: 79,
      sort_order: 10,
      active: true,
      shipping_length: 10,
      shipping_width: 5,
      shipping_height: 2,
      shipping_weight: 2,
      assembled_stock: 0,

      kit_stock: 0,
      partial_stock: 0,

      kits_to_make: 0,
      partials_to_make: 0,
      assembled_to_make: 0
    }}

    trait :bad do
      option_editor {{
        model: 'KF-2S',
        description: 'option description',
        upc: '123456789012',
        price: 329,
        discount: 79,
        sort_order: 10,
        active: true,
        shipping_length: 0,
        shipping_width: 0,
        shipping_height: 0,
        shipping_weight: 0,
        assembled_stock: 0,

        kit_stock: 0,
        partial_stock: 0,

        kits_to_make: 0,
        partials_to_make: 0,
        assembled_to_make: 0
      }}
    end

    factory :bad_editor, traits: [:bad]

    initialize_with { new(attributes) }
  end
end
