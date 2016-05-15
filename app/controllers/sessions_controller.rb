 class SessionsController < ApplicationController
  
  include ProductUtilities
  
  before_action :set_cart, :set_products
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to home_url
  end
  
end
