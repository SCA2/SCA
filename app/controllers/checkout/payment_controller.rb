module Checkout
  class PaymentController < Checkout::CheckoutController
    
    before_action :set_no_cache
    before_action :empty_cart_redirect
    before_action :cart_purchased_redirect
    before_action :bad_state_redirect
    before_action :save_progress

    def new
      @card = CardTokenizer.new(order)
      @card.email = current_user.email if signed_in?
    end

    def update
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

    def bad_state_redirect
      unless order.payable?
        flash[:alert] = 'Sorry, there was a problem getting your shipping details.'
        redirect_to new_checkout_shipping_path(cart)
      end
    end

    def order_params
      params.require(:card_tokenizer).
      permit(:stripe_token, :email).
      merge(ip_address: request.remote_ip)
    end
  end
end