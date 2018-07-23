class RemoveProductIdFromLineItems < ActiveRecord::Migration[5.1]
  def change
    remove_index :line_items, column: :product_id
    remove_column :line_items, :product_id, :integer
  end
end
