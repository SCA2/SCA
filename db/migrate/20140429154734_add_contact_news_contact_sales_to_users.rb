class AddContactNewsContactSalesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact_sales, :boolean
    add_column :users, :contact_news, :boolean
  end
end
