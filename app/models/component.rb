class Component < ApplicationRecord
  has_many :line_items, inverse_of: :component, dependent: :restrict_with_exception
  has_many :bom_items, inverse_of: :component, dependent: :restrict_with_exception
  has_one :bom, inverse_of: :component, dependent: :destroy
  has_many :options, inverse_of: :component, dependent: :restrict_with_exception
  has_many :products, through: :options, dependent: :restrict_with_exception
  has_one :size_weight_price_tag, inverse_of: :component, dependent: :destroy

  delegate :shipping_length, :shipping_width, to: :size_weight_price_tag
  delegate :shipping_height, :shipping_weight, to: :size_weight_price_tag
  delegate :full_price_in_cents, :discount_price_in_cents, to: :size_weight_price_tag

  attribute :restock_quantity, :integer, default: 0

  validates :mfr_part_number, presence: true
  validates :mfr_part_number, uniqueness: { message: "%{value} is taken" }, on: :create

  validates :vendor_part_number, uniqueness: { message: "%{attribute} is taken" }, on: :create, if: Proc.new { vendor_part_number.present? }

  validates :stock, numericality: { only_integer: true}, allow_blank: true
  validates :lead_time, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

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

  def child_items
    if bom
      bom.bom_items.includes(:component).flat_map { |item| [item] + item.component.child_items }
    else
      []
    end
  end

  def bom_lead_time
    if bom
      stock_out = child_items.group_by { |item| item.component.stock }[0]
      stock_out.max_by { |item| item.component.lead_time }.component.lead_time if stock_out
    elsif self[:lead_time]
      self[:lead_time]
    else
      nil
    end
  end

  def recursive_stock
    if bom && local_stock <= 0
      bom.stock
    elsif stocked?
      self[:stock]
    else
      0
    end
  end

  def bom_stock
    bom.stock if bom
  end

  def local_stock
    self[:stock] if stocked?
  end

  def stocked?
    !unstocked?
  end

  def unstocked?
    self[:stock].nil?
  end

  def pick(quantity: 0)
    return unless stocked?
    self.reload if self.persisted?
    if bom && local_stock < quantity
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