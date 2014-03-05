class RenameProductOptionsToOptions < ActiveRecord::Migration
  def change
    rename_table :product_options, :options
  end
end
