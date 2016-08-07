module Checkout
  class ShippingController < Checkout::CheckoutController
    
    before_action :set_no_cache
    before_action :empty_cart_redirect
    before_action :cart_purchased_redirect
    before_action :bad_state_redirect
    before_action :save_progress

    def new
      shipper = OrderShipper.new(order)
      @ups_rates = shipper.ups_rates
      @usps_rates = shipper.usps_rates
      @paypal_url = PaypalRedirector.url(order)
    rescue StandardError => e
      flash[:error] = e.message
      redirect_to new_checkout_address_path(cart)
    end
    
    def update
      if order.update(order_params)
        shipper = OrderShipper.new(order)
        shipper.get_rates_from_params(order_params[:shipping_method])
        flash[:success] = 'Shipping method saved!'
        redirect_to new_checkout_confirmation_path(cart)
      else
        flash.now[:alert] = 'Please select a shipping method!'
        render 'new'
      end
    rescue NoMethodError => e
      flash.now[:alert] = 'Please select a shipping method!'
      render 'new'
    end

  private

    def bad_state_redirect
      unless order.shippable?
        flash[:alert] = 'Sorry, there was a problem creating your addresses.'
        redirect_to new_checkout_address_path(cart)
      end
    end

    def order_params
      params.require(:order).permit(:id, :shipping_method, :shipping_cost)
    end
  end
end