module Checkout
  class ConfirmationController < ApplicationController

    include ProductUtilities

    before_action :set_no_cache
    before_action :set_products
    before_action :set_checkout_cart
    before_action :set_checkout_order
    before_action :cart_purchased_redirect
    before_action :empty_cart_redirect
    before_action :save_progress

    def new
      unless @billing = @order.billing_address
        flash[:alert] = 'Billing address is missing!'
        redirect_to new_checkout_address_path(@cart) and return
      end
      unless @shipping = @order.shipping_address
        flash[:alert] = 'Shipping address is missing!'
        redirect_to new_checkout_address_path(@cart) and return
      end
      unless @order.shipping_method
        flash[:alert] = 'Shipping method is missing!'
        redirect_to new_checkout_shipping_path(@cart) and return
      end
      unless @order.shipping_cost
        flash[:alert] = 'Shipping cost is missing!'
        redirect_to new_checkout_shipping_path(@cart) and return
      end
      @calculator = SalesTaxCalculator.new(@order)
      @terms = TermsValidator.new
    end
    
    def update
      bad_state_redirect; return if performed?
      if TermsValidator.new(order_params).valid?
        sales_tax = SalesTaxCalculator.new(@order).sales_tax
        @order.update(sales_tax: sales_tax)
        flash[:success] = 'Order confirmed!'
        redirect_to paypal_redirect
      else
        flash[:alert] = 'You must accept terms to proceed!'
        redirect_to new_checkout_confirmation_path(@cart)
      end 
    end

  private

    def bad_state_redirect
      unless @order.confirmable?
        flash[:alert] = 'Sorry, there was a problem confirming your order.'
        redirect_to new_checkout_confirmation_path(@cart)
      end
    end

    def paypal_redirect
      if @order.express_token.to_s.length > 1
        edit_checkout_payment_path(@cart)
      else
        new_checkout_payment_path(@cart, accept_terms: '1')
      end
    end

    def order_params
      params.require(:order).
      require(:terms_validator).
      permit(:accept_terms)
    end

  end
end

