class Transaction < ActiveRecord::Base
  belongs_to :order
  serialize :params
  
  def response=(response)
    self.success        = response.success?
    self.authorization  = response.authorization
    self.message        = response.message
    self.params         = response.params
  rescue StandardError => e
    self.success        = false
    self.authorization  = 'failed'
    self.message        = e.message
    self.params         = {}
  end
end
