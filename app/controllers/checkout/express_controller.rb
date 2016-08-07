module Checkout
  class ExpressController < Checkout::CheckoutController
  
    before_action :set_no_cache
    before_action :cart_purchased_redirect
    before_action :empty_cart_redirect

    def new
      @order = Order.find_or_create_by(cart_id: cart.id)
      bad_state_redirect; return if performed?
      response = EXPRESS_GATEWAY.setup_purchase(cart.subtotal, express_options)
      redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    end
    
    def edit
      @order = cart.order
      bad_state_redirect; return if performed?
      if ExpressValidator.new(@order, order_params)
        flash[:success] = 'Got PayPal authorization!'
        redirect_to new_checkout_shipping_path(cart)
      else
        flash[:alert] = 'Sorry, unable to continue checkout.'
        redirect_to products_path
      end
    end

  private

    def bad_state_redirect
      unless @order.addressable?
        flash[:alert] = 'Sorry, unable to continue checkout.'
        redirect_to products_path
      end
    end

    def express_options
      options = {
        ip:                   request.remote_ip,
        return_url:           edit_checkout_express_url(cart),
        cancel_return_url:    cart_url(cart),
        payment_action:       'sale',
        currency:             'USD',
        brand_name:           'Seventh Circle Audio',
        allow_guest_checkout: 'true',
        subtotal:             cart.subtotal
      }
      
      options[:items] = cart.line_items.map do |line_item|
        {
          name: line_item.model,
          description: line_item.product.category + ', ' + line_item.option.description,
          quantity: line_item.quantity,
          amount: line_item.price
        }
      end

      if (discount = cart.discount) > 0
        options[:items] << { name: 'Discount', quantity: 1, amount: -discount }
      end

      return options
    end
    
    def order_params
      params.permit(:token, :PayerID).merge(ip_address: request.remote_ip)
    end

  end
end