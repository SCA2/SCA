class Component < ApplicationRecord
  has_many :line_items, as: :itemizable, inverse_of: :component
  has_many :bom_items, inverse_of: :component, dependent: :restrict_with_exception

  validates :mfr_part_number, :stock, :lead_time, presence: true
  validates :mfr_part_number, uniqueness: { message: "%{value} is taken" }, on: :create
  validates :vendor_part_number, uniqueness: { message: "%{attribute} is taken" }, on: :create, if: Proc.new { vendor_part_number.present? }
  validates :stock, numericality: { only_integer: true }
  validates :lead_time, numericality: { only_integer: true, greater_than: 0 }

  default_scope -> { order :mfr_part_number }

  def item_model
    mfr_part_number
  end
  
  def item_description
    description
  end

  def price_in_cents
    0
  end

  def discount_in_cents
    0
  end

  def shipping_length
    0
  end

  def shipping_width
    0
  end

  def shipping_height
    0
  end

  def shipping_weight
    0
  end

  def self.permitted_attributes
    self.column_names - ['id', 'created_at', 'updated_at']
  end

  def selection_name
    name = mfr_part_number.strip
    name += ", #{value.strip}" if value.present?
    name += ", #{description.strip}" if description.present?
    name
  end
end