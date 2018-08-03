class AddXorConstraintToLineItem < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TABLE line_items ADD CONSTRAINT line_items_xor check(
      (option_id is not null)::integer +
      (component_id is not null)::integer + 
      (misc_id is not null)::integer = 1);"
  end
end
