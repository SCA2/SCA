class OrdersController < ApplicationController

  include ProductUtilities
  
  before_action :set_cart, :set_products
  before_action :admin_user

  def index
    @orders = Order.order(:created_at)    
  end
  
  def show
    # byebug
    @order = Order.find(order_params)
    # @order = @cart.order
    @billing = @order.billing_address
    @shipping = @order.shipping_address

    if !@order.valid? || @billing == nil || @shipping == nil || @cart == nil
      redirect_to orders_path, alert: "Invalid record" and return
    end
  end
  
  # def subregion_options
  #   if @order.addresses.any?
  #     @billing = @order.addresses.find_by(address_type: 'billing')
  #     @shipping = @order.addresses.find_by(address_type: 'shipping')
  #   end
  #   render partial: 'subregion_select'
  # end
  
  def destroy
    @order = @cart.order
    if @order
      @order.destroy
      @cart.destroy
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
