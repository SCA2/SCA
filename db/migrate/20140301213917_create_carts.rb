class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :line_items, index: true

      t.timestamps
    end
  end
end
