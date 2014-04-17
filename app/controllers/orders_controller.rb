class OrdersController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :set_order, except: [:create, :express, :create_express]

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
    response = EXPRESS_GATEWAY.setup_purchase(@cart.build_order.price_in_cents,
      :ip                   => request.remote_ip,
      :return_url           => create_express_orders_url,
      :cancel_return_url    => products_url,
      :currency             => 'USD',
      :brand_name           => 'Seventh Circle Audio',
      :allow_guest_checkout => 'true'
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  def create_express
    token = params[:token]
    @order = Order.create(:express_token => token)
    @order.get_express_address(token)
    redirect_to shipping_order_path(@order)
  end
  
  def addresses
    @billing = @order.addresses.build(address_type: 'billing')
    @shipping = @order.addresses.build(address_type: 'shipping')
    if signed_in?
      @billing = current_user.addresses.find_by(address_type: 'billing').dup
      @shipping = current_user.addresses.find_by(address_type: 'shipping').dup
    end
  end
  
  def create_addresses
    @order.update(order_params)
    if @order.save
      redirect_to shipping_order_path(@order), notice: 'Addresses saved'
    else
      redirect_to current_cart, notice: 'Sorry, address could not be saved'
    end
  end
  
  def box_size
    #if module_count > 2 then medium
    #if module_count > 6 then multiple
    #if CH02_count > 0 then large
    #if CH02_count > 1 then multiple    
  end
  
  def shipping
    @order.weight = 15 * 16
    @order.length = 24
    @order.width = 12
    @order.height = 6
  end
  
  def update_shipping
    if @order.update(order_params)
      @order.get_rates_from_params
      redirect_to confirm_order_path(@order)
    else
      render 'new', notice: 'Sorry, shipping method could not be updated'
    end
  end

  def confirm
    if @order.express_token
      @redirect = order_path(@order)
    else
      @redirect = update_confirm_order_path(@order)
    end
  end
  
  def update_confirm
    if @order.express_token
      redirect_to update_path(@order)
    else
      redirect_to payment_order_path(@order)
    end
  end

  def payment
    if signed_in?
      @order.email = current_user.email
    end
  end
  
  def update
    @order.order_ready = true
    if @order.update(order_params)
      @order.cart = @cart
      @order.ip_address = request.remote_ip
      if @order.purchase
        @transaction = @order.transactions.last
        UserMailer.order_received(@order).deliver
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        render 'success'
      else
        @transaction = @order.transactions.last
        render :action => 'failure'
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
      params.require(:order).permit(:cart_id, :email, :card_type, :card_expires_on, :card_number, :card_verification, :ip_address, :express_token,
                                    :shipping_method, :shipping_cost, :length, :width, :height, :weight, 
                                    :addresses_attributes => [:id, :address_type, :first_name, :last_name, :address_1, :address_2, :city, :state, :post_code, :country, :telephone])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:order_id, :user_id, :address_type, :first_name, :last_name, :address_1, :address_2, :city, :state, :post_code, :country, :telephone)
    end
    
end
