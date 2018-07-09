class AddInvoiceNameToCarts < ActiveRecord::Migration[5.1]
  def change
    add_column :carts, :invoice_name, :string
  end
end
