class TermsValidator

  include ActiveModel::Model

  attr_accessor :accept_terms

  validates :accept_terms, acceptance: true

  def initialize(params = nil)
    @accept_terms = params[:accept_terms] unless params.nil?
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'TermsValidator')
  end

end