class MakeLineItemsPolymorphic < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :itemizable_id, :integer
    add_column :line_items, :itemizable_type, :string
    LineItem.update_all("itemizable_id=option_id")
  end
end
