class RemoveModelFromFeatures < ActiveRecord::Migration
  def change
    remove_column :features, :model, :string
  end
end
