class AddShippedAtToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :shipped_at, :datetime
  end
end
