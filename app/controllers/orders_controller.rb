# click checkout
# show checkout method form
# get checkout method

# if create order as guest
# show address form
# get billing address
# show address form
# get shipping address
# get shipping cost
# show shipping method form
# get shipping method
# show order confirmation form
# get order confirmation
# show payment form
# get payment info
# process payment
# show transaction result form
# send confirmation email

# if create order as registered user
# show login form
# validate user
# if addresses exist
#   retrieve billing address
#   retrieve shipping address
# else
#   show address form
#   get billing address
#   show address form
#   get shipping address
# get shipping cost
# show shipping method form
# get shipping method
# show order confirmation form
# get order confirmation
# show payment form
# get payment info
# process payment
# show transaction result form
# send confirmation email

# create PayPal express order
# redirect to PayPal (authorize)
# callback 1 from PayPal
# get shipping cost
# show shipping method form
# get shipping method
# show order confirmation form
# get order confirmation
# redirect to PayPal (capture)
# callback 2 from PayPal
# process payment
# show transaction result form
# send confirmation email


class OrdersController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :set_order, except: [:new, :create, :express, :create_express]

  # serve checkout method form
  def new
    if @cart.line_items.empty?
      redirect_to products_url, notice: "Your cart is empty"
      return
    else
      @order = Order.new
    end
  end
  
  # create order as guest
  # create order as registered user
  # create PayPal express order
  def create
    @order = Order.create(:express_token => params[:token])
    redirect_to billing_order_path(@order)
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
    redirect_to shipper_order_path(@order)
  end
  
  def billing
    @type = 'billing'
    @address = @order.addresses.new
  end
  
  def create_billing
    @address = @order.addresses.new(address_params)
    if @address.save
      redirect_to shipping_order_path(@order), notice: 'Billing address created'
    else
      render 'new', notice: 'Sorry, address could not be saved'
    end
  end
  
  def shipping
    @type = 'shipping'
    @address = @order.addresses.new
  end
  
  def create_shipping
    @address = @order.addresses.new(address_params)
    if @address.save
      redirect_to shipper_order_path(@order), notice: 'Billing address created'
    else
      render 'new', notice: 'Sorry, address could not be saved'
    end
  end
  
  def shipper
    @order.weight = 15 * 16
    @order.length = 24
    @order.width = 12
    @order.height = 6
  end
  
  def update_shipper
    if @order.update(order_params)
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
  end
  
  def update
    if @order.update(order_params)
      @order.cart = @cart
      @order.ip_address = request.remote_ip
      if @order.purchase
        @transaction = @order.transactions.last
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        render :action => 'success'
      else
        @transaction = @order.transactions.last
        render :action => 'failure'
      end
    else
      render action: 'new'
    end
  end
    
  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:cart_id, :email, :card_type, :card_expires_on, :card_number, :card_verification, :ip_address, :express_token, :shipping_method, :length, :width, :height, :weight, 
                                    :addresses_attributes => [:id, :address_type, :first_name, :last_name, :address_1, :address_2, :city, :state, :post_code, :country, :telephone])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:order_id, :user_id, :address_type, :first_name, :last_name, :address_1, :address_2, :city, :state, :post_code, :country, :telephone)
    end
    
end
