class AddCurrentOptionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :current_option, :integer
  end
end
