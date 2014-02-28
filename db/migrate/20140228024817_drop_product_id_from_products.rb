class DropProductIdFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :product_id
  end
end
