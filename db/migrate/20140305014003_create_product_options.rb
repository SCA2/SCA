class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options do |t|
      t.string :model
      t.string :description
      t.integer :price
      t.string :upc
      t.integer :shipping_weight
      t.integer :finished_stock
      t.integer :kit_stock
      t.integer :part_stock
      t.integer :option_sort_order

      t.timestamps
    end
  end
end
