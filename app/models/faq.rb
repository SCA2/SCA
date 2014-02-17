class Faq < ActiveRecord::Base
  validates :group, :question, :answer, :priority, presence: true
  
  validates :group, inclusion: { in: %w(General Ordering Assembly Support),
                                 message: "--> %{value} is not a valid group" }
  validates :priority, numericality: {only_integer: true, 
                                      greater_than: 0,
                                      less_than: 101}
                                      
  validates :question, uniqueness: { scope: :group }
end
