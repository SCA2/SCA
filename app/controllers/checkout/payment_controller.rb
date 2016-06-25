module Checkout
  class PaymentController < ApplicationController
    
    include ProductUtilities
    
    before_action :set_no_cache
    before_action :set_products
    before_action :set_checkout_cart
    before_action :set_checkout_order
    before_action :cart_purchased_redirect
    before_action :empty_cart_redirect

    def new
      unless @order.confirmable? && params[:accept_terms]
        flash[:alert] = 'Sorry, there was a problem confirming your order.'
        redirect_to new_checkout_confirmation_path(@cart) and return
      end
    
      @order.email = current_user.email if signed_in?
    end

    def edit
      unless @order.express_token
        flash[:alert] = 'Sorry, there was a problem with your PayPal Express payment.'
        redirect_to new_checkout_confirmation_path(@cart) and return
      end

      if @order.purchase
        redirect_to new_checkout_transaction_path(@cart, success: true)
      else
        redirect_to new_checkout_transaction_path(@cart, success: false)
      end
    end

    def update
      unless @order.confirmable?
        flash[:alert] = 'Sorry, there was a problem with your payment details.'
        redirect_to new_checkout_confirmation_path(@cart) and return
      end

      unless @order.update(order_params)
        render 'new' and return
      end

      if @order.purchase
        redirect_to new_checkout_transaction_path(@cart, success: true)
      else
        redirect_to new_checkout_transaction_path(@cart, success: false)
      end
    end

  private

    def order_params
      params.require(:order).
      permit(:card_type, :card_number, :card_expires_on,  :card_verification, :email).
      merge({ip_address: request.remote_ip, validate_order: true})
    end
  end
end