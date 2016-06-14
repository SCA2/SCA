class Transaction < ActiveRecord::Base
  belongs_to :order
  serialize :params
  
  def response=(response)
    if response
      self.success        = response.success?
      self.authorization  = response.authorization
      self.message        = response.message
      self.params         = response.params
    else
      self.success        = false
      self.authorization  = 'failed'
      self.message        = 'response not received'
      self.params         = {}
    end
  end
end
