module Checkout
  class TransactionsController < ApplicationController

    include ProductUtilities
    
    before_action :set_products

    def new
      @cart = get_cart
      @order = Order.find(params[:id])
      @transaction = @order.transactions.last
      if order_params[:success] == 'true'
        @order.cart.inventory
        @cart.save
        UserMailer.order_received(@order).deliver_now
        session[:cart_id] = nil
        session[:progress] = nil
        @order.update(state: @order.next_state(:success))
        render 'success'
      else
        @order.update(state: @order.next_state(:failure))
        render 'failure'
      end
    end

  private

    def order_params
      params.permit(:id, :success)
    end
  end
end