class AddTrackingNumberToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :tracking_number, :string
  end
end
