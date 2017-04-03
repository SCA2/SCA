module Checkout
  class TransactionsController < Checkout::CheckoutController

    before_action :set_no_cache
    before_action :empty_cart_redirect
    before_action :bad_state_redirect

    def new
      if OrderPurchaser.new(order).purchase
        @transaction = order.transactions.last
        flash[:success] = 'Thank you for your order!'
        cart.inventory
        cart.save
        send_mail
        forget_cart
        render 'success'
      elsif order.stripe_purchase?
        @transaction = order.transactions.last
        flash[:alert] = 'Sorry, we had a problem with your credit card payment.'
        render 'failure'
      elsif order.express_purchase?
        @transaction = order.transactions.last
        flash[:alert] = 'Sorry, there was a problem with your PayPal Express payment.'
        render 'failure'
      end
    end

  private
    def send_mail
      UserMailer.order_received(order).deliver_now
    end

    def bad_state_redirect
      unless order.transactable?(order_params[:accept_terms])
        flash[:alert] = 'Sorry, there was a problem confirming your order.'
        redirect_to new_checkout_confirmation_path(order)
      end
    end

    def forget_cart
      @cart = nil
      session[:cart_id] = nil
      session[:progress] = nil
    end

    def order_params
      params.permit(:accept_terms)
    end
  end
end