class RemoveCurrentOptionFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :current_option, :integer
  end
end
