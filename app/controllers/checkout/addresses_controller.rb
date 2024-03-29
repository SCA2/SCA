module Checkout
  class AddressesController < Checkout::CheckoutController
    
    before_action :set_no_cache
    before_action :empty_cart_redirect
    before_action :cart_purchased_redirect
    before_action :bad_state_redirect
    before_action :save_progress

    def new
      order.update(express_token: nil)
      assign_address('billing')
      assign_address('shipping')
    end

    def create
      copy_billing_to_shipping if use_billing_for_shipping?
      if order.update(order_params)
        flash[:success] = 'Addresses saved!'
        if order.intangible?
          redirect_to new_checkout_payment_path(cart)
        else
          redirect_to new_checkout_shipping_path(cart)
        end
      else
        render 'new'
      end
    end

  private

    def bad_state_redirect
      unless order.addressable?
        flash[:alert] = 'Sorry, unable to continue checkout.'
        redirect_to products_path
      end
    end

    def assign_address(type)
      unless order.addresses.exists?(address_type: type)
        if signed_in? && current_user.addresses.exists?(address_type: type)
          order.addresses << current_user.addresses.find_by(address_type: type).dup
        else
          order.addresses.build(address_type: type)
        end
      end
    end

    def use_billing_for_shipping?
      order_params[:use_billing] == 'yes'
    end

    def billing_address_exists?
      order.addresses.exists?(address_type: 'billing')
    end

    def shipping_address_exists?
      order.addresses.exists?(address_type: 'shipping')
    end

    def copy_billing_to_shipping
      billing = params[:order][:addresses_attributes]['0'].dup
      billing[:address_type] = 'billing'
      if billing_address_exists?
        billing[:id] = order.addresses.find_by(address_type: 'billing').id
      else
        billing[:id] = nil
      end

      shipping = billing.dup
      shipping[:address_type] = 'shipping'
      if shipping_address_exists?
        shipping[:id] = order.addresses.find_by(address_type: 'shipping').id
      else
        shipping[:id] = nil
      end

      params[:order][:addresses_attributes]['0'] = billing
      params[:order][:addresses_attributes]['1'] = shipping
    end

    ADDRESS_ATTRIBUTES = [:id, [:address_type, :first_name, :last_name,
      :address_1, :address_2, :city, :state_code, :post_code, :country,
      :telephone]]

    def order_params
      params.require(:order).permit(:id, :use_billing, addresses_attributes: ADDRESS_ATTRIBUTES)
    end
  end
end