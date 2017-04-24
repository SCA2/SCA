module Checkout
  class TransactionsController < Checkout::CheckoutController

    before_action :set_no_cache
    before_action :empty_cart_redirect
    before_action :bad_state_redirect

    def new
      if OrderPurchaser.new(order).purchase
        @transaction = order.transactions.last

        # for display only, not persisted
        @transaction.authorization.gsub!('ch_', '')

        flash[:success] = 'Thank you for your order!'
        cart.inventory
        cart.save
        send_mail
        @cart = nil
        session[:cart_id] = nil
        render 'success'
      else
        @transaction = order.transactions.last
        flash[:alert] = 'Sorry, we had a problem with your credit card payment.'
        render 'failure'
      end
      session[:progress] = nil
    end

  private
    def send_mail
      UserMailer.order_received(order).deliver_now
    end

    def bad_state_redirect
      unless order.transactable?
        flash[:alert] = 'Sorry, there was a problem confirming your order.'
        redirect_to new_checkout_confirmation_path(order)
      end
    end
  end
end