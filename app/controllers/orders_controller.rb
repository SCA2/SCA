class OrdersController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def new
    if @cart.line_items.empty?
      redirect_to products_url, notice: "Your cart is empty"
      return
    end
    @order = Order.new(:express_token => params[:token])
  end

  def create
    @order = @cart.build_order(order_params)
    @order.ip_address = request.remote_ip
    if @order.save
      if @order.purchase
        @transaction = @order.transactions.find_by(order_id: @order).last
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
end
