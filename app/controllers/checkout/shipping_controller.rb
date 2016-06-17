module Checkout
  class ShippingController < ApplicationController
    
    require 'active_shipping'
    include ProductUtilities
    
    before_action :set_no_cache
    before_action :set_checkout_cart, :set_products
    before_action :cart_purchased_redirect
    before_action :empty_cart_redirect
    before_action :save_progress

    def new
      @order = @cart.order
      bad_state_redirect; return if performed?
      @paypal_url = get_paypal_url(@order.express_token)
      @ups_rates = @order.ups_rates
      @usps_rates = @order.usps_rates
    rescue ActiveShipping::ResponseError => e
      flash[:error] = e.message
      redirect_to new_checkout_address_path(@cart)
    end
    
    def update
      @order = @cart.order
      bad_state_redirect; return if performed?
      if @order.update(order_params)
        @order.get_rates_from_params
        flash[:success] = 'Shipping method saved!'
        redirect_to new_checkout_confirmation_path(@cart)
      else
        flash[:alert] = 'Please select a shipping method!'
        render 'new'
      end
    rescue ActionController::ParameterMissing
      flash.now[:alert] = 'Please select a shipping method!'
      render 'new'
    end

  private

    def bad_state_redirect
      unless @order.shippable?
        flash[:alert] = 'Sorry, there was a problem creating your addresses.'
        redirect_to new_checkout_address_path(@cart)
      end
    end

    def get_paypal_url(token)
      if token
        EXPRESS_GATEWAY.redirect_url_for(token)
      else
        nil
      end
    end

    def order_params
      params.require(:order).permit(:id, :shipping_method, :shipping_cost)
    end
  end
end