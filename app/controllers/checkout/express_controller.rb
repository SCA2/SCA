module Checkout
  class ExpressController < ApplicationController
  
    include ProductUtilities

    before_action :set_cart
    before_action :checkout_complete_redirect
    before_action :empty_cart_redirect

    def new
      response = EXPRESS_GATEWAY.setup_purchase(@cart.subtotal, express_options)
      redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    end
    
    def create
      token = params[:token]
      if @cart.order
        @order = @cart.order
        @order.update(express_token: token)
      else
        @order = Order.new(express_token: token)
        @order.cart = @cart
      end
      @order.get_express_address(token)
      @order.update(state: 'order_addressed')
      flash[:success] = 'Got PayPal token!'
      redirect_to new_checkout_shipping_path(id: @order)
    end

  private

    def express_options
      options = {
        ip:                   request.remote_ip,
        return_url:           checkout_express_url,
        cancel_return_url:    cart_url(@cart),
        payment_action:       'sale',
        currency:             'USD',
        brand_name:           'Seventh Circle Audio',
        allow_guest_checkout: 'true',
        subtotal:             @cart.subtotal
      }
      
      options[:items] = @cart.line_items.map do |line_item|
        {
          name: line_item.model,
          description: line_item.product.category + ', ' + line_item.option.description,
          quantity: line_item.quantity,
          amount: line_item.price
        }
      end

      if (discount = @cart.discount) > 0
        options[:items] << { name: 'Discount', quantity: 1, amount: -discount }
      end

      return options
    end

  end
end