class CheckoutController < ApplicationController
  
  include ProductUtilities
  
  before_action :set_cart, :set_products
  before_action :cart_purchased_redirect
  before_action :empty_cart_redirect

  def new
    redirect_to new_checkout_address_path(@cart)
  end
    
end