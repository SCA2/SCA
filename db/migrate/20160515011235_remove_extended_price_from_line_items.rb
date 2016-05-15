class RemoveExtendedPriceFromLineItems < ActiveRecord::Migration
  def change
    remove_column :line_items, :extended_price, :integer
  end
end
