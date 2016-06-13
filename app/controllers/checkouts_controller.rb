class CheckoutsController < ApplicationController
  
  include ProductUtilities
  
  before_action :set_cart, :set_products
  before_action :checkout_complete_redirect
  before_action :empty_cart_redirect

  def new
    redirect_to new_checkout_address_path
  end
    
end