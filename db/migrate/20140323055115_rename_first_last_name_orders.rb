class RenameFirstLastNameOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.rename :first_name,  :shipping_first_name
      t.rename :last_name,  :shipping_last_name
    end
  end
end
