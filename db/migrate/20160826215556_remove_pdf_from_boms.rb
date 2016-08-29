class RemovePdfFromBoms < ActiveRecord::Migration
  def change
    remove_column :boms, :pdf, :string
  end
end
