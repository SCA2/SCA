class Option < ApplicationRecord
  
  belongs_to :product, inverse_of: :options
  belongs_to :component, inverse_of: :option

  # enforced by pg foreign key constraint
  has_many :line_items, as: :itemizable, inverse_of: :option, dependent: :restrict_with_exception
  
  delegate :full_price, :discount_price, to: :component
  delegate :full_price_in_cents, :discount_price_in_cents, to: :component
  delegate :shipping_length, :shipping_width, :shipping_height, :shipping_weight, to: :component
  delegate :stock, :lead_time, to: :component

  validates :sort_order, uniqueness: { scope: :product }
  validates :product, :component, presence: true
  validates_inclusion_of :active, in: [true, false]

  scope :sorted, -> { order :sort_order }

  STOCK_CUTOFF = 12
  LEAD_TIME_CUTOFF = 10

  def model
    if component
      component.mfr_part_number
    else
      self[:model]
    end
  end

  def description
    if component
      component.description
    else
      self[:description]
    end
  end

  def item_model
    component.mfr_part_number
  end

  def item_description
    "#{product.category}, #{component.description}"
  end

  def active?
    self.active
  end

  def enabled?
    active? && component.present?
  end

  def disabled?
    !enabled?
  end

  def stock_message
    if disabled?
      "Not available at this time"
    elsif component.stock > STOCK_CUTOFF
      "Can ship today"
    elsif component.stock > 0
      "#{component.stock} can ship today"
    elsif component.stock <= 0 and component.lead_time <= LEAD_TIME_CUTOFF
      "Can ship in #{component.lead_time} #{'day'.pluralize(component.lead_time)}"
    else
      "Please <a href='mailto:sales@seventhcircleaudio.com'>email</a> for lead time".html_safe
    end
  end
end

