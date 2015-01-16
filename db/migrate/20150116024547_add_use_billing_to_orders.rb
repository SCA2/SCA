class AddUseBillingToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :use_billing, :string
  end
end
