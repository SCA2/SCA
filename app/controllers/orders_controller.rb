class OrdersController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :set_order, except: [:new, :create]

  def new
    @order = Order.new
    if @cart.line_items.empty?
      redirect_to products_url, notice: "Your cart is empty"
      return
    end
  end
  
  def create
    @order = Order.create(:express_token => params[:token])
    redirect_to billing_order_path(@order)
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
  end
  
  def update_shipper
    redirect_to payment_order_path(@order)
  end

  def payment
  end
  
  def update_payment
    redirect_to confirm_order_path(@order)
  end

  def confirm
  end
  
  def update_confirm
    redirect_to products_path
  end

  def update
#    @order = @cart.build_order(order_params)
    @order.add_line_items_from_cart(@cart)
    @order.ip_address = request.remote_ip
    if @order.save
      if @order.purchase
        @transaction = @order.transactions.find_by(order_id: @order).last
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        render :action => 'success'
      else
        render :action => 'failure'
      end
    else
      render action: 'new'
    end
  end
  
  def express
    response = EXPRESS_GATEWAY.setup_purchase(current_cart.build_order.price_in_cents,
      :ip                => request.remote_ip,
      :return_url        => new_order_url,
      :cancel_return_url => products_url
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  
  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:cart_id, :first_name, :last_name, :shipping_address_1, :shipping_address_2, :shipping_city, :shipping_state, :shipping_post_code, :shipping_country, :email, :telephone, :card_type, :card_expires_on, :cart_id, :card_number, :card_verification, :ip_address, :express_token)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:order_id, :user_id, :address_type, :first_name, :last_name, :address_1, :address_2, :city, :state, :post_code, :country, :telephone)
    end
    
end
