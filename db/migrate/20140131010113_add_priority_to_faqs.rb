class AddPriorityToFaqs < ActiveRecord::Migration
  def change
    add_column :faqs, :priority, :integer
  end
end
