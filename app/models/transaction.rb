class Transaction < ActiveRecord::Base
  belongs_to :order
  serialize :params

  validates :tracking_number, length: { minimum: 6 }, on: :update
  validates :tracking_number, presence: true, on: :update

  def response=(response)
    if response
      self.success        = response.success?
      self.authorization  = response.authorization
      self.message        = response.message
      self.params         = response.params
    else
      self.success        = false
      self.authorization  = 'failed'
      self.message        = 'invalid response'
      self.params         = {}
    end
  end
end
