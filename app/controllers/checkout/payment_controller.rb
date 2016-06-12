module Checkout
  class PaymentController < ApplicationController
    
    include ProductUtilities
    
    before_action :set_cart, :set_products
    before_action :checkout_complete_redirect
    before_action :empty_cart_redirect

    def new
      @order = Order.find(params[:id])
      if @order.order_confirmed?
        @order.email = current_user.email if signed_in?
      else
        flash[:alert] = 'Sorry, there was a problem confirming your order.'
        redirect_to new_checkout_confirmation_path(id: @order)
      end
    end

    def update
      @order = Order.find(params[:id])
      @order.update(state: @order.next_state)
      @order.validate_order = true
      if @order.payment_submitted?
        if @order.update(order_params)
          if @order.purchase
            redirect_to new_checkout_transaction_path(success: true)
          else
            redirect_to new_checkout_transaction_path(success: false)
          end
        else
          render 'new'
          @order.validate_order = false
          @order.update(state: 'order_confirmed')
        end
      else
        @order.validate_order = false
        @order.update(state: 'order_confirmed')
        flash[:alert] = 'Sorry, there was a problem submitting your payment.'
        redirect_to new_checkout_payment_path(id: @order)
      end
    end

  private

    def order_params
      params.require(:order).permit(:id, :email, :card_type, :card_expires_on, :card_number, :card_verification)
    end
  end
end