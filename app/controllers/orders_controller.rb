class OrdersController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :admin_user, only: [:index]
  before_action :set_order, except: [:index, :subregion_options, :create, :express, :create_express]

  def index
    @orders = Order.order(:created_at)    
  end
  
  def show
    @billing = @order.addresses.find_by(:address_type => 'billing')
    @shipping = @order.addresses.find_by(:address_type => 'shipping')
    @cart = @order.cart
    
    if !@order.valid? || @billing == nil || @shipping == nil || @cart == nil
      redirect_to orders_path, alert: "Invalid record"
      return
    end
  end
  
  def create
    if @cart.line_items.empty?
      flash[:notice] = 'Your cart is empty'
      redirect_to products_path
      return
    else
      @order = Order.create(:cart_id => @cart.id)
      redirect_to addresses_order_path(@order)
    end
  end
  
  def express
    if @cart.line_items.empty?
      flash[:notice] = 'Your cart is empty'
      redirect_to products_path
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
    @order.addresses.clear
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
      flash[:success] = 'Addresses saved!'
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
      flash[:alert] = 'Addresses are missing!'
      redirect_to shipping_order_path(@order)
    end
  end
  
  def update_confirm
    @order.validate_terms = true
    if @order.update(order_params)
      redirect_to payment_order_path @order
    else
      flash[:alert] = 'You must accept terms to proceed'
      redirect_to confirm_order_path(@order)
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
        flash[:alert] = 'You must accept terms to proceed'
        redirect_to confirm_order_path
        return
      end 
    end
    
    @order.validate_order = true
    if @order.update(order_params)
      @order.ip_address = request.remote_ip
      if @order.purchase
        @transaction = @order.transactions.last
        @order.cart.inventory
        @order.cart = @cart
        @order.save
        @cart.save
        UserMailer.order_received(@order).deliver
#        Cart.destroy(session[:cart_id])
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
    
  def destroy
    @order.destroy
    redirect_to orders_path
  end

  private
    
    def order_params
      params.require(:order).permit(:id, :cart_id, :email,
                                    :card_type, :card_expires_on, :card_number, :card_verification,
                                    :ip_address, :express_token, :accept_terms,
                                    :shipping_method, :shipping_cost, :length, :width, :height, :weight, 
                                    :addresses_attributes => [:id, :address_type, :first_name, :last_name, :address_1,
                                    :address_2, :city, :state_code, :post_code, :country, :telephone])
    end

    def admin_user
      unless signed_in_admin?
        flash[:alert] = 'Sorry, admins only'
        redirect_to(home_path)
      end
    end

    def set_order
      @order = Order.find(params[:id])
    end

end
