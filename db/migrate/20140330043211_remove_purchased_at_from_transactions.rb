class RemovePurchasedAtFromTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :purchased_at, :datetime
  end
end
