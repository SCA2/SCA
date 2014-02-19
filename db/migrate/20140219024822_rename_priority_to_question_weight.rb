class RenamePriorityToQuestionWeight < ActiveRecord::Migration
  def change
    change_table :faqs do |t|
      t.rename :priority, :question_weight
    end
  end
end
