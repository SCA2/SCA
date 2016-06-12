module Checkout
  class ConfirmationController < ApplicationController

    include ProductUtilities

    before_action :set_cart, :set_products
    before_action :checkout_complete_redirect
    before_action :empty_cart_redirect

    def new
      @order = Order.find(params[:id])
      if @order.viewable?
        # @form_url = update_confirm_order_path(@order)
        if @order.addresses.any?
          @billing = @order.addresses.find_by(address_type: 'billing')
          @shipping = @order.addresses.find_by(address_type: 'shipping')
        else
          flash[:alert] = 'Addresses are missing!'
          redirect_to shipping_order_path(@order)
        end
      else
        flash[:alert] = 'Sorry, there was a problem creating your shipping method.'
        redirect_to new_checkout_shipping_path(id: @order)
      end
    end
    
    def update
      @order = Order.find(params[:id])
      @order.validate_terms = true
      if @order.update(order_params)
        flash[:success] = 'Order confirmed!'
        paypal_redirect
      else
        flash[:alert] = 'You must accept terms to proceed'
        redirect_to new_checkout_confirmation_path(id: @order)
      end 
    end

  private

    def paypal_redirect
      @order.update(state: @order.next_state)
      if @order.express_token.to_s.length > 1
        update and return
      else
        redirect_to new_checkout_payment_path(id: @order)
      end
    end

    def order_params
      params.require(:order).permit(:id, :accept_terms)
    end

  end
end