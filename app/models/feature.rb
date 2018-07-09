class Feature < ApplicationRecord
  
  belongs_to :product, inverse_of: :features

  validates :product_id, :sort_order, :caption, :description, presence: true
  validates :sort_order, numericality: {only_integer: true, greater_than: 0, less_than: 501}
  validates :caption, uniqueness: { scope: :product_id }

  def self.next_feature
    feature = Feature.new
    if Feature.count > 0
      last_feature = Feature.order(:created_at).last
      feature.sort_order = last_feature.sort_order + 10
    else
      feature.sort_order = 10
    end
    return feature
  end

end
