class RenameTableOrderTransaction < ActiveRecord::Migration
  def change
    rename_table :order_transactions, :transactions
  end
end
