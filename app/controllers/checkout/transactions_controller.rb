module Checkout
  class TransactionsController < ApplicationController

    include ProductUtilities
    
    before_action :set_cart, :set_products
    before_action :checkout_complete_redirect
    before_action :empty_cart_redirect

    def new
      @order = Order.find(params[:id])
      if order_params[:success]
        @transaction = @order.transactions.last
        @order.cart.inventory
        @cart.save
        UserMailer.order_received(@order).deliver_now
        session[:cart_id] = nil
        session[:progress] = nil
        @order.update(state: @order.next_state(:success))
        render 'success'
      else
        @transaction = @order.transactions.last
        @order.update(state: @order.next_state(:failure))
        render 'failure'
      end
    end

  private

    def order_params
      params.require(:order).permit(:id, :success)
    end
  end
end