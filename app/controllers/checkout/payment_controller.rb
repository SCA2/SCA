module Checkout
  class PaymentController < Checkout::CheckoutController
    
    before_action :set_no_cache
    before_action :cart_purchased_redirect
    before_action :empty_cart_redirect

    def new
      unless order.confirmable? && params[:accept_terms]
        flash[:alert] = 'Sorry, there was a problem confirming your order.'
        redirect_to new_checkout_confirmation_path(cart) and return
      end
      @card = CardValidator.new(order)
      @card.email = current_user.email if signed_in?
    end

    def edit
      unless order.express_purchase?
        flash[:alert] = 'Sorry, there was a problem with your PayPal Express payment.'
        redirect_to new_checkout_confirmation_path(cart) and return
      end

      if OrderPurchaser.new(order).purchase
        flash[:success] = 'Thank you for your order!'
        redirect_to new_checkout_transaction_path(cart, success: true)
      else
        flash[:alert] = 'Sorry, we had a problem with your PayPal Express payment.'
        redirect_to new_checkout_transaction_path(cart, success: false)
      end
    end

    def create
      unless order.standard_purchase?
        flash[:alert] = 'Sorry, there was a problem with your payment details.'
        redirect_to new_checkout_confirmation_path(cart) and return
      end

      @card = CardValidator.new(order, order_params)
      if @card.valid?
        @card.save
      else
        render 'new' and return
      end

      if OrderPurchaser.new(order, @card).purchase
        flash[:success] = 'Thank you for your order!'
        redirect_to new_checkout_transaction_path(cart, success: true)
      else
        flash[:alert] = 'Sorry, we had a problem with your credit card payment.'
        redirect_to new_checkout_transaction_path(cart, success: false)
      end
    end

  private

    def order_params
      params.require(:card_validator).
      permit(:card_type, :card_number, :card_expires_on,  :card_verification, :email).
      merge(ip_address: request.remote_ip)
    end
  end
end