class RemoveRevisionFromBoms < ActiveRecord::Migration
  def change
    remove_column :boms, :revision, :string
  end
end
