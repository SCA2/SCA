class AddInvoiceTokenToCarts < ActiveRecord::Migration[5.0]
  def change
    add_column :carts, :invoice_token, :string
    add_column :carts, :invoice_sent_at, :datetime
    add_index  :carts, :invoice_token
  end
end
