class FaqsCategory < ActiveRecord::Base

  has_many :faqs, inverse_of: :faqs_category, dependent: :destroy
  accepts_nested_attributes_for :faqs

  validates :category_name, uniqueness: :true, presence: :true
  validates :category_weight, uniqueness: :true, numericality: {only_integer: true, greater_than: 0, less_than: 101}

  before_destroy :ensure_not_referenced_by_any_faq

  private

    def ensure_not_referenced_by_any_faq
      if faqs.empty?
        return true
      else
        errors.add(:base, 'FAQs present')
        return false
      end
    end

end
