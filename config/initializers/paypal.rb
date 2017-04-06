SCA::Application.configure do  
  #Paypal
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :production
    paypal_options = {
      login:      ENV['PAYPAL_PRO_LOGIN'],
      password:   ENV['PAYPAL_PRO_PASSWORD'],
      signature:  ENV['PAYPAL_PRO_SIGNATURE']
    }
    ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end