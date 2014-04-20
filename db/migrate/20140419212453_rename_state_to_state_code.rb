class RenameStateToStateCode < ActiveRecord::Migration
  def change
    rename_column :addresses, :state, :state_code
  end
end
