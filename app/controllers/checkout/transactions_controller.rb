module Checkout
  class TransactionsController < Checkout::CheckoutController

    before_action :set_no_cache
    before_action :empty_cart_redirect
    before_action :bad_state_redirect

    def new
      @transaction = order.transactions.last
      if order_params[:success] == 'true'
        cart.inventory
        cart.save
        UserMailer.order_received(order).deliver_now
        forget_cart
        render 'success'
      else
        render 'failure'
      end
    end

  private

    def bad_state_redirect
      unless order.notifiable?
        flash[:alert] = 'Sorry, there was a problem submitting your payment.'
        redirect_to new_checkout_payment_path(order)
      end
    end

    def forget_cart
      @cart = nil
      session[:cart_id] = nil
      session[:progress] = nil
    end

    def order_params
      params.permit(:id, :success)
    end
  end
end