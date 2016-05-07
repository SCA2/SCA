class AddDefaultToOptionsActive < ActiveRecord::Migration
  def change
    change_column :options, :active, :boolean, null: false, default: true
  end
end
