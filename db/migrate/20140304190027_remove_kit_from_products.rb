class RemoveKitFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :kit, :string
  end
end
