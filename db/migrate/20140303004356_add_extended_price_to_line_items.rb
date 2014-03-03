class AddExtendedPriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :extended_price, :integer
  end
end
