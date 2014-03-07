class RemoveInCartFromOptions < ActiveRecord::Migration
  def change
    remove_column :options, :in_cart, :boolean
  end
end
