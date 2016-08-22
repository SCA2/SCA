class RemoveProductIdFromBoms < ActiveRecord::Migration
  def change
    remove_column :boms, :product_id, :integer
  end
end
