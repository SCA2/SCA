class RemoveOptionFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :option, :string
  end
end
