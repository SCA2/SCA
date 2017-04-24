module Checkout
  class ConfirmationController < Checkout::CheckoutController

    before_action :set_no_cache
    before_action :empty_cart_redirect
    before_action :cart_purchased_redirect
    before_action :bad_state_redirect
    before_action :save_progress

    def new
      @billing = order.billing_address
      @shipping = order.shipping_address
      @calculator = OrderCalculator.new(order)
      @terms = TermsValidator.new
    end
    
    def update
      @terms = TermsValidator.new(order_params)
      if @terms.valid?
        sales_tax = OrderCalculator.new(order).sales_tax
        order.update(sales_tax: sales_tax, confirmed: true)
        redirect_to new_checkout_transaction_path(cart)
      else
        flash.now[:alert] = 'You must accept terms to proceed!'
        @terms.errors.clear
        @billing = order.billing_address
        @shipping = order.shipping_address
        @calculator = OrderCalculator.new(order)
        render :new
      end 
    end

  private

    def bad_state_redirect
      unless order.confirmable?
        flash[:alert] = 'Sorry, there was a problem with your payment.'
        redirect_to new_checkout_payment_path(cart)
      end
    end

    def order_params
      params.require(:order).
      require(:terms_validator).
      permit(:accept_terms)
    end

  end
end

