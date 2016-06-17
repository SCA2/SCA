module Checkout
  class PaymentController < ApplicationController
    
    include ProductUtilities
    
    before_action :set_no_cache
    before_action :set_checkout_cart, :set_products
    before_action :cart_purchased_redirect
    before_action :empty_cart_redirect

    def new
      @order = @cart.order
      bad_new_state_redirect; return if performed?
      @order.email = current_user.email if signed_in?
    end

    def edit
      @order = @cart.order
      bad_edit_state_redirect; return if performed?
      if @order.purchase
        redirect_to new_checkout_transaction_path(@cart, success: true)
      else
        redirect_to new_checkout_transaction_path(@cart, success: false)
      end
    end

    def update
      @order = @cart.order
      bad_update_state_redirect; return if performed?
      if @order.update(order_params)
        if @order.purchase
          redirect_to new_checkout_transaction_path(@cart, success: true)
        else
          redirect_to new_checkout_transaction_path(@cart, success: false)
        end
      else
        render 'new'
      end
    end

  private

    def bad_new_state_redirect
      unless @order.confirmable? && flash[:accept_terms]
        flash[:alert] = 'Sorry, there was a problem confirming your order.'
        redirect_to new_checkout_confirmation_path(@cart)
      end
    end

    def bad_edit_state_redirect
      unless @order.express_token
        flash[:alert] = 'Sorry, there was a problem with your PayPal Express payment.'
        redirect_to new_checkout_confirmation_path(@cart)
      end
    end

    def bad_update_state_redirect
      unless @order.confirmable?
        flash[:alert] = 'Sorry, there was a problem with your payment details.'
        redirect_to new_checkout_confirmation_path(@cart)
      end
    end

    def order_params
      params.require(:order).
      permit(:id, :email, :card_type, :card_expires_on, :card_number, :card_verification).
      merge({ip_address: request.remote_ip, validate_order: true})
    end
  end
end