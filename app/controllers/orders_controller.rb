class OrdersController < ApplicationController

  include ProductUtilities
  
  before_action :set_cart, :set_products
  before_action :set_no_cache
  before_action :save_progress, except: [:express, :create_express, :payment]
  before_action :admin_user, only: [:index, :show]

  def index
    @orders = Order.order(:created_at)    
  end
  
  def show
    @billing = @order.addresses.find_by(address_type: 'billing')
    @shipping = @order.addresses.find_by(address_type: 'shipping')
    @cart = @order.cart
    
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
    if @order.cart
      cart = @order.cart
      @order.destroy
      cart.destroy
    else
      @order.destroy
    end
    redirect_to orders_path
  end

  def delete_abandoned
    orders = Order.order(:created_at)
    orders.each do |order|
      email = order.email
      billing = order.addresses.find_by(address_type: 'billing')
      shipping = order.addresses.find_by(address_type: 'shipping')
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
    time_range = start..stop
    @tax = {}

    all_orders = Order.includes(:cart).where(carts: { purchased_at: time_range })
    @tax[:orders] = Order.
      includes(:cart).
      includes(:addresses).
      where(carts: { purchased_at: time_range }).
      where(addresses: { address_type: 'shipping' }).
      where(addresses: { state_code: 'CA' })

    @tax[:gross_sales] = all_orders.reduce(0) { |sum, order| sum + order.total }
    @tax[:taxable_sales] = @tax[:orders].reduce(0) { |sum, order| sum + order.total }
    @tax[:excluded_sales] = @tax[:gross_sales] - @tax[:taxable_sales]
    @tax[:shipping] = @tax[:orders].reduce(0) { |sum, order| sum + order.shipping_cost }
    @tax[:tax_withheld] = @tax[:orders].reduce(0) { |sum, order| sum + order.sales_tax }
  end

private

  def admin_user
    unless signed_in_admin?
      flash[:alert] = 'Sorry, admins only'
      redirect_to(home_path)
    end
  end

end
