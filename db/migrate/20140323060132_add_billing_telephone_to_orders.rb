class AddBillingTelephoneToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :billing_telephone, :string
  end
end
