class AddActiveFlagToProducts < ActiveRecord::Migration
  def change
    add_column :products, :active, :boolean, null: false, default: true
  end
end