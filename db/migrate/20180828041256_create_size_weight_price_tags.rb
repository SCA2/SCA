class CreateSizeWeightPriceTags < ActiveRecord::Migration[5.1]
  def change
    create_table :size_weight_price_tags do |t|
      t.bigint :component_id
      t.string :upc
      t.integer :full_price, default: 0
      t.integer :discount_price, default: 0
      t.integer :shipping_length, default: 0
      t.integer :shipping_width, default: 0
      t.integer :shipping_height, default: 0
      t.integer :shipping_weight, default: 0
      t.timestamps
    end
  end
end
