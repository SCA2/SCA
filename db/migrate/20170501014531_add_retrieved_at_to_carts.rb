class AddRetrievedAtToCarts < ActiveRecord::Migration[5.0]
  def change
    add_column :carts, :invoice_retrieved_at, :datetime
  end
end
