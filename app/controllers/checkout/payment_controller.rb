module Checkout
  class PaymentController < Checkout::CheckoutController
    
    before_action :set_no_cache
    before_action :cart_purchased_redirect
    before_action :empty_cart_redirect
    before_action :save_progress

    def new
      unless order.shipping_method
        flash[:alert] = 'Shipping method is missing!'
        redirect_to new_checkout_shipping_path(cart) and return
      end
      unless order.shipping_cost
        flash[:alert] = 'Shipping cost is missing!'
        redirect_to new_checkout_shipping_path(cart) and return
      end
      @card = CardTokenizer.new(order)
      @card.email = current_user.email if signed_in?
    end

    def update
      unless order.payable?
        flash[:alert] = 'Sorry, there was a problem with your shipping details.'
        redirect_to new_checkout_shipping_path(cart) and return
      end

      @card = CardTokenizer.new(order, order_params)
      if @card.valid?
        @card.save
        flash[:success] = 'Card token saved!'
        redirect_to new_checkout_confirmation_path(cart)
      else
        render 'new'
      end
    end

  private

    def order_params
      params.require(:card_tokenizer).
      permit(:stripe_token, :email).
      merge(ip_address: request.remote_ip)
    end
  end
end