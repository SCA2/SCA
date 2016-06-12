class CheckoutsController < ApplicationController
  
  include ProductUtilities
  
  before_action :set_cart, :set_products
  before_action :checkout_complete_redirect
  before_action :empty_cart_redirect

  def new
    redirect_to new_checkout_address_path
  end

private

  # def purchase_order
  #   @order.ip_address = request.remote_ip
  #   if @order.purchase
  #     @transaction = @order.transactions.last
  #     @order.cart.inventory
  #     @cart.save
  #     UserMailer.order_received(@order).deliver_now
  #     session[:cart_id] = nil
  #     session[:progress] = nil
  #     @order.update(state: @order.next_state(:success))
  #     render 'success'
  #   else
  #     @transaction = @order.transactions.last
  #     @order.update(state: @order.next_state(:failure))
  #     render 'failure'
  #   end
  # end

  # def order_params
  #   params.require(:order).permit(:id, :email, :card_type, :card_expires_on, :card_number, :card_verification)
  # end
    
end