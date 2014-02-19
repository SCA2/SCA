class RenameGroupToCategory2 < ActiveRecord::Migration
  def change
    change_table :faqs do |t|
      t.rename :group, :category
    end
  end
end
