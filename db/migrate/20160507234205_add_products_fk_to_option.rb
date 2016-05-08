class AddLineItemFkToOption < ActiveRecord::Migration
  def change
    add_foreign_key :options, :products, name: 'options_product_fk', on_delete: :cascade
  end
end
