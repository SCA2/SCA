module Checkout
  class TransactionsController < ApplicationController

    include ProductUtilities
    
    before_action :set_no_cache
    before_action :set_checkout_cart, :set_products
    before_action :empty_cart_redirect

    def new
      @order = @cart.order
      bad_state_redirect; return if performed?
      @transaction = @order.transactions.last
      if order_params[:success] == 'true'
        @cart.inventory
        @cart.save
        UserMailer.order_received(@order).deliver_now
        session[:cart_id] = nil
        session[:progress] = nil
        set_cart
        render 'success'
      else
        render 'failure'
      end
    end

  private

    def bad_state_redirect
      unless @order.notifiable?
        flash[:alert] = 'Sorry, there was a problem submitting your payment.'
        redirect_to new_checkout_payment_path(@order)
      end
    end

    def order_params
      params.permit(:id, :success)
    end
  end
end