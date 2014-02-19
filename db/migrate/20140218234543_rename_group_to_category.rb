class RenameGroupToCategory < ActiveRecord::Migration
  def change
    rename_column :faqs, :group, :category
  end
end
