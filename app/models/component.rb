class Component < ActiveRecord::Base
  has_many :bom_items, inverse_of: :component, dependent: :restrict_with_exception

  validates :mfr_part_number, :stock, :lead_time, presence: true
  validates :mfr_part_number, :vendor_part_number, uniqueness: true
  validates :stock, numericality: { only_integer: true, greater_than: -1 }
  validates :lead_time, numericality: { only_integer: true, greater_than: 0 }

  default_scope -> { order :mfr_part_number }

  def self.permitted_attributes
    self.column_names - ['id', 'created_at', 'updated_at']
  end

  def selection_name
    "#{mfr_part_number}, #{value}, #{description}"
  end
end