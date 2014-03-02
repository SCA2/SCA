class DropLineItemsIdFromCartsTable < ActiveRecord::Migration
  def change
    remove_column :carts, :line_items_id
  end
end
