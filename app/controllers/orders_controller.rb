class OrdersController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :set_order, except: [:subregion_options, :create, :express, :create_express]

  def create
    if @cart.line_items.empty?
      redirect_to products_url, notice: "Your cart is empty"
      return
    else
      @order = Order.create(:cart_id => @cart.id)
      redirect_to addresses_order_path(@order)
    end
  end
  
  def express
    if @cart.line_items.empty?
      redirect_to products_url, notice: "Your cart is empty"
      return
    else
      response = EXPRESS_GATEWAY.setup_purchase(@cart.build_order.subtotal_in_cents,
        :ip                   => request.remote_ip,
        :return_url           => create_express_orders_url,
        :cancel_return_url    => products_url,
        :currency             => 'USD',
        :brand_name           => 'Seventh Circle Audio',
        :allow_guest_checkout => 'true'
      )
      redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    end
  end
  
  def create_express
    token = params[:token]
    @order = Order.new(:express_token => token)
    @order.get_express_address(token)
    @order.cart = @cart
    @order.save
    redirect_to shipping_order_path(@order)
  end
  
  def subregion_options
    if @order.addresses.any?
      @billing = @order.addresses.find_by(:address_type => 'billing')
      @shipping = @order.addresses.find_by(:address_type => 'shipping')      
    end
    render partial: 'subregion_select'
  end
  
  def addresses
    if signed_in? && current_user.addresses.any?
      @order.addresses << current_user.addresses.find_by(address_type: 'billing').dup
      @order.addresses << current_user.addresses.find_by(address_type: 'shipping').dup
    else
      @order.addresses.build(address_type: 'billing')
      @order.addresses.build(address_type: 'shipping')
    end
  end
  
  def create_addresses
    @order.update(order_params)
    if @order.save
      redirect_to shipping_order_path(@order)
    else
      render 'addresses'
    end
  end
  
  def shipping
  end
  
  def update_shipping
    if @order.update(order_params)
      @order.get_rates_from_params
      redirect_to confirm_order_path(@order)
    else
      render 'shipping'
    end
  end

  def confirm
    if @order.express_token.to_s.length > 1
      @redirect = order_path(@order)
    else
      @redirect = update_confirm_order_path(@order)
    end
    if @order.addresses.any?
      @billing = @order.addresses.find_by(:address_type => 'billing')
      @shipping = @order.addresses.find_by(:address_type => 'shipping')
    else
      redirect_to shipping_order_path(@order), alert: 'Addresses not saved!'
    end
  end
  
  def update_confirm
    @order.validate_terms = true
    if @order.update(order_params)
      redirect_to payment_order_path @order
    else
      redirect_to confirm_order_path, alert: 'You must accept terms to proceed'
    end 
  end

  def payment
    if signed_in?
      @order.email = current_user.email
    end
  end
  
  def update
    if @order.express_token.to_s.length > 1
      @order.validate_terms = true
      unless @order.update(order_params)
        redirect_to confirm_order_path, alert: 'You must accept terms to proceed'
        return
      end 
    end
    
    @order.validate_order = true
    if @order.update(order_params)
      @order.cart = @cart
      @order.ip_address = request.remote_ip
      if @order.purchase
        @transaction = @order.transactions.last
        @order.cart.inventory
        UserMailer.order_received(@order).deliver
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        render 'success'
      else
        @transaction = @order.transactions.last
        render 'failure'
      end
    else
      render 'payment'
    end
  end
    
  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:cart_id, :email, :card_type, :card_expires_on, :card_number, :card_verification, :ip_address, :express_token, :accept_terms,
                                    :shipping_method, :shipping_cost, :length, :width, :height, :weight, 
                                    :addresses_attributes => [:id, :address_type, :first_name, :last_name, :address_1, :address_2, :city, :state_code, :post_code, :country, :telephone])
    end

end
