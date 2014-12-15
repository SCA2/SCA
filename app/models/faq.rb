class Faq < ActiveRecord::Base

  belongs_to :faqs_category, inverse_of: :faqs

  validates :faqs_category, :question, :question_weight, :answer, presence: true
  validates :question_weight, numericality: {only_integer: true, greater_than: 0, less_than: 501}
  validates :question, uniqueness: { scope: :faqs_category }
  
  def self.next_faq
    faq = Faq.new
    if Faq.count > 0
      last_faq = Faq.last
      faq.question_weight = last_faq.question_weight + 10
      faq.faqs_category = last_faq.faqs_category
    else
      faq.question_weight = 10
      faq.faqs_category = FaqsCategory.first
    end
    return faq
  end
      

end
