class AddInCartToOptions < ActiveRecord::Migration
  def change
    add_column :options, :in_cart, :boolean
  end
end
