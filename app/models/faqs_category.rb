class FaqsCategory < ActiveRecord::Base

  has_many :faqs, inverse_of: :faqs_category, dependent: :destroy
  before_destroy :check_for_faqs, prepend: true

  validates :category_name, uniqueness: :true, presence: :true
  validates :category_weight, uniqueness: :true, numericality: {only_integer: true, greater_than: 0, less_than: 101}


  private

    def check_for_faqs
      return true unless faqs.any?
      errors.add(:base, 'Category still has FAQs!')
      throw :abort
    end

end
