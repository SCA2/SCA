class AddSpecsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :specifications, :string
  end
end
