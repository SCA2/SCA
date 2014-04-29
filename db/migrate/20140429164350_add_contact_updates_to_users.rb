class AddContactUpdatesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact_updates, :boolean
  end
end
