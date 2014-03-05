class AddShippingWeightToProducts < ActiveRecord::Migration
  def change
    add_column :products, :shipping_weight, :integer
  end
end
