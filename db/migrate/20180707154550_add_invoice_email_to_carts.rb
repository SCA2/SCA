class AddInvoiceEmailToCarts < ActiveRecord::Migration[5.1]
  def change
    add_column :carts, :invoice_email, :string
  end
end
