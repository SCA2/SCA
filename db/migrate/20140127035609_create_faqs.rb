class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :group
      t.text :question
      t.text :answer

      t.timestamps
    end
  end
end
