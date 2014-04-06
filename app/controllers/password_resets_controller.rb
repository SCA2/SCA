class PasswordResetsController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products

  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, notice: 'Password reset instructions sent!'
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: 'Reset link has expired.'
    elsif @user.update(password_params)
      redirect_to root_url, notice: 'Password reset!'
    else
      render :edit
    end
  end
  
  private
  
    def password_params
      params.require(:id).permit(:user)
    end
end
