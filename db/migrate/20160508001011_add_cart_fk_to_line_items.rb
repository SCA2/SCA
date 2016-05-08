class AddCartFkToLineItems < ActiveRecord::Migration
  def change
    add_foreign_key :line_items, :carts, name: 'line_items_carts_fk', on_delete: :cascade
  end
end
