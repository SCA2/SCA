module Checkout
  class ShippingController < ApplicationController
    
    include ProductUtilities
    
    before_action :set_cart, :set_products
    before_action :checkout_complete_redirect
    before_action :empty_cart_redirect

    def new
      @order = Order.find(params[:id])
      @ups_rates = @order.ups_rates
      @usps_rates = @order.usps_rates
      unless @order.viewable?
        flash[:alert] = 'Sorry, there was a problem creating your addresses.'
        redirect_to new_checkout_address_path(id: @order)
      end
    rescue ActiveMerchant::Shipping::ResponseError => e
      flash[:error] = e.message
      redirect_to new_checkout_address_path(id: @order.id)
    end
    
    def update
      @order = Order.find(params[:id])
      if @order.update(order_params)
        @order.get_rates_from_params
        @order.update(state: 'shipping_method_selected')
        flash[:success] = 'Shipping method saved!'
        redirect_to new_checkout_confirmation_path(id: @order)
      else
        flash[:alert] = 'Please select a shipping method!'
        render 'shipping'
      end
    rescue ActionController::ParameterMissing
      flash[:alert] = 'Please select a shipping method!'
      redirect_to new_checkout_shipping_path(@order)
    end

  private

    def order_params
      params.require(:order).permit(:id, :shipping_method, :shipping_cost)
    end
  end
end