class AddTransactionsOrdersFk < ActiveRecord::Migration
  def change
    add_foreign_key :transactions, :orders, name: 'transactions_orders_fk', on_delete: :cascade
  end
end
