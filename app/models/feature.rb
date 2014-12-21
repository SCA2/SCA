class Feature < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :features
  default_scope -> { order('sort_order ASC') }
  validates :product_id, :caption, :sort_order, :description, presence: true
  
  def self.next_feature
    feature = Feature.new
    byebug
    if Feature.count > 0
      last_feature = Feature.order(:created_at).last
      feature.sort_order = last_feature.sort_order + 10
    else
      feature.sort_order = 10
    end
    return feature
  end

end
