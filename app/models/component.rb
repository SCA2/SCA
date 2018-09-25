class Component < ApplicationRecord
  has_many :line_items, as: :itemizable, inverse_of: :component
  has_many :bom_items, inverse_of: :component, dependent: :restrict_with_exception
  has_one :bom, inverse_of: :component
  has_one :option, inverse_of: :component, dependent: :restrict_with_exception
  has_one :size_weight_price_tag, inverse_of: :component, dependent: :destroy

  delegate :shipping_length, :shipping_width, :shipping_height, :shipping_weight, to: :size_weight_price_tag
  delegate :full_price_in_cents, :discount_price_in_cents, to: :size_weight_price_tag

  attribute :restock_quantity, :integer, default: 0

  validates :mfr_part_number, presence: true
  validates :mfr_part_number, uniqueness: { message: "%{value} is taken" }, on: :create

  validates :vendor_part_number, uniqueness: { message: "%{attribute} is taken" }, on: :create, if: Proc.new { vendor_part_number.present? }

  validates :stock, numericality: { only_integer: true}, allow_blank: true
  validates :lead_time, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
  # validates :lead_time, numericality: { greater_than: 0, allow_blank: true }, allow_blank: true

  validates :restock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  default_scope -> { order :mfr_part_number }
  scope :tagged, -> { joins(:size_weight_price_tag) }
  scope :priced, -> { tagged.where.not(size_weight_price_tags: { full_price: 0 }) }

  def item_model
    mfr_part_number
  end
  
  def item_description
    description
  end

  def bom_lead_time
    if self[:stock] && self[:stock] > 0
      self[:lead_time]
    elsif bom && bom.stock
      bom.lead_time
    else
      nil
    end
  end

  def bom_stock
    if self[:stock] && self[:stock] > 0
      self[:stock]
    elsif self[:stock] && !bom
      self[:stock]
    elsif bom && bom.stock
      bom.stock
    else
      nil
    end
  end

  def pick(quantity: 0)
    self.reload if self.persisted?
    return unless self[:stock]
    if bom && self[:stock] < quantity
      bom.pick(quantity: quantity - self[:stock])
      self[:stock] = 0
    else
      self[:stock] -= quantity
    end
  end

  def pick!(quantity: 0)
    pick(quantity: quantity)
    self.save!
  end

  def restock(quantity: 0)
    return unless self[:stock]
    bom.pick(quantity: quantity) if bom && bom.stock >= quantity
    self[:stock] += quantity
  end

  def restock!(quantity: 0)
    restock(quantity: quantity)
    self.save!
  end

  def self.permitted_attributes
    self.attribute_names - ['id', 'created_at', 'updated_at']
  end

  def selection_name
    name = mfr_part_number.strip
    name += ", #{value.strip}" if value.present?
    name += ", #{description.strip}" if description.present?
    name
  end
end