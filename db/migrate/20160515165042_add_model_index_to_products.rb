class AddModelIndexToProducts < ActiveRecord::Migration
  def change
    add_index :products, :model
  end
end
