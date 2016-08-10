class Component < ActiveRecord::Base
  has_many :bom_items, inverse_of: :component, dependent: :restrict_with_exception

  default_scope -> { order :mfr_part_number }

  def self.permitted_attributes
    self.column_names - ['id', 'created_at', 'updated_at']
  end
end