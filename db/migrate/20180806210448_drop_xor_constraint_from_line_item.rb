class DropXorConstraintFromLineItem < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TABLE line_items DROP CONSTRAINT line_items_xor;"
  end
end
