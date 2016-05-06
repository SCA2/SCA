class AddActiveFlagToOptions < ActiveRecord::Migration
  def change
    add_column :options, :active, :boolean
  end
end
