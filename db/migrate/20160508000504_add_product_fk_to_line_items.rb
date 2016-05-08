class AddProductFkToLineItems < ActiveRecord::Migration
  def change
    add_foreign_key :line_items, :products, name: 'line_items_product_fk', on_delete: :restrict
  end
end
