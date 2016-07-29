class PaypalRedirector

  require 'active_merchant/billing/rails'

  def self.url(order)
    return nil unless order
    return nil if order.purchased?
    return nil if order.express_token.blank?
    EXPRESS_GATEWAY.redirect_url_for(order.express_token)
  end

end