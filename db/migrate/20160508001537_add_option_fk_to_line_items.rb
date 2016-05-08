class AddOptionFkToLineItems < ActiveRecord::Migration
  def change
    add_foreign_key :line_items, :options, name: 'line_items_options_fk', on_delete: :restrict
  end
end
