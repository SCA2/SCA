class Faq < ActiveRecord::Base
  
  validates :category, :category_weight, :question, :question_weight, :answer, presence: true
  
  validates :category, inclusion: { in: %w(General Ordering Assembly Support),
                                 message: "--> %{value} is not a valid category" }
  validates :category_weight, :question_weight, 
    numericality: {only_integer: true, greater_than: 0, less_than: 501}
                                      
  validates :question, uniqueness: { scope: :category }
  
  def self.next_faq
    faq = Faq.new
    if Faq.count > 0
      last_faq = Faq.last
      faq.question_weight = last_faq.question_weight + 10
      faq.category_weight = last_faq.category_weight
      faq.category = last_faq.category
    else
      faq.question_weight = 10
      faq.category_weight = 10
      faq.category = 'General'
    end
    return faq
  end
      

end
