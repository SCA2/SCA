class OrdersController < BaseController

  before_action :admin_user

  def index
    @orders = Order.order(:created_at)    
  end
  
  def show
    @order = Order.find(order_params)
    @cart = @order.cart
    @billing = @order.billing_address
    @shipping = @order.shipping_address

    if !@order.valid? || @billing == nil || @shipping == nil || @cart == nil
      redirect_to orders_path, alert: "Invalid record" and return
    end
  end
  
  def destroy
    order = Order.find(order_params)
    if order
      cart = order.cart
      order.destroy
      cart.destroy
    end
    redirect_to orders_path
  end

  def delete_abandoned
    orders = Order.order(:created_at)
    orders.each do |order|
      email = order.email
      billing = order.billing_address
      shipping = order.shipping_address
      cart = order.cart  
      transaction = order.transactions.last
      order.destroy unless email && billing && shipping && cart && transaction
    end
    redirect_to orders_path and return
  end

  def search
    start = params[:from].to_date.beginning_of_day
    stop = params[:to].to_date.end_of_day
    time_range = start..stop
    @orders = Order.joins(:cart).where(carts: { purchased_at: time_range })
    render 'index'
  end

  def sales_tax
    start = params[:from].to_date.beginning_of_day
    stop = params[:to].to_date.end_of_day
    @tax = SalesTaxCalculator.new(start..stop)
  end

private
  def order_params
    params.require(:id)
  end

  def admin_user
    unless signed_in_admin?
      flash[:alert] = 'Sorry, admins only'
      redirect_to(home_path)
    end
  end

end
