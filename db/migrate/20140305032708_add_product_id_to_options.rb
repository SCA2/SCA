class AddProductIdToOptions < ActiveRecord::Migration
  def change
    add_column :options, :product_id, :integer
  end
end
