class AddIdToProducts < ActiveRecord::Migration
  def change
     add_column :products, :product_id, :integer
  end
end
