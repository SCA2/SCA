class OrdersController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  before_action :set_no_cache
  before_action :save_progress, except: [:express, :create_express, :payment]
  before_action :admin_user, only: [:index]
  before_action :set_order, except: [:index, :create, :express, :create_express, :delete_abandoned, :search, :sales_tax]

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
  
  def create
    if @cart.line_items.empty?
      flash[:notice] = 'Your cart is empty'
      redirect_to products_path and return
    elsif @cart.order
      @order = @cart.order
      bad_state_redirect
    else
      @order = Order.create(cart_id: @cart.id)
      bad_state_redirect
    end
  end
  
  def express
    if @cart.line_items.empty?
      flash[:notice] = 'Your cart is empty'
      redirect_to products_path and return
    else
      response = EXPRESS_GATEWAY.setup_purchase(@cart.subtotal, express_options)
      redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    end
  end
  
  def create_express
    token = params[:token]
    if @cart.order
      @order = @cart.order
      @order.update(express_token: token)
    else
      @order = Order.new(express_token: token)
      @order.cart = @cart
    end
    @order.get_express_address(token)
    @order.update(state: 'order_addressed')
    flash[:success] = 'Got PayPal token!'
    redirect_to shipping_order_path(@order)
  end
  
  def subregion_options
    if @order.addresses.any?
      @billing = @order.addresses.find_by(address_type: 'billing')
      @shipping = @order.addresses.find_by(address_type: 'shipping')
    end
    render partial: 'subregion_select'
  end
  
  def addresses
    if @order.viewable?
      assign_address('billing')
      assign_address('shipping')
    else
      flash[:alert] = 'Sorry, there was a problem creating your order.'
      bad_state_redirect
    end
  end

  def create_addresses
    copy_billing_to_shipping if use_billing_for_shipping?
    if @order.update(order_params)
      flash[:success] = 'Addresses saved!'
      @order.update(state: 'order_addressed')
      redirect_to shipping_order_path(@order)
    else
      render 'addresses'
    end
  end
  
  def shipping
    unless @order.viewable?
      flash[:alert] = 'Sorry, there was a problem creating your addresses.'
      bad_state_redirect
    end
  rescue ActiveMerchant::Shipping::ResponseError => e
    flash[:error] = e.message
    redirect_to addresses_order_path(@order)
  end
  
  def update_shipping
    if @order.update(order_params)
      @order.get_rates_from_params
      @order.update(state: 'shipping_method_selected')
      flash[:success] = 'Shipping method saved!'
      redirect_to confirm_order_path(@order)
    else
      flash[:alert] = 'Please select a shipping method!'
      render 'shipping'
    end
  rescue ActionController::ParameterMissing
    flash[:alert] = 'Please select a shipping method!'
    redirect_to shipping_order_path(@order)
  end

  def confirm
    if @order.viewable?
      @form_url = update_confirm_order_path(@order)
      if @order.addresses.any?
        @billing = @order.addresses.find_by(address_type: 'billing')
        @shipping = @order.addresses.find_by(address_type: 'shipping')
      else
        flash[:alert] = 'Addresses are missing!'
        redirect_to shipping_order_path(@order)
      end
    else
      flash[:alert] = 'Sorry, there was a problem creating your shipping method.'
      bad_state_redirect
    end
  end
  
  def paypal_redirect
    @order.update(state: @order.next_state)
    if @order.express_token.to_s.length > 1
      update and return
    else
      redirect_to payment_order_path @order
    end
  end

  def update_confirm
    @order.validate_terms = true
    if @order.update(order_params)
      flash[:success] = 'Order confirmed!'
      paypal_redirect
    else
      flash[:alert] = 'You must accept terms to proceed'
      redirect_to confirm_order_path(@order)
    end 
  end

  def payment
    if @order.viewable?
      @order.email = current_user.email if signed_in?
    else
      flash[:alert] = 'Sorry, there was a problem confirming your order.'
      bad_state_redirect
    end
  end
  
  def update
    @order.update(state: @order.next_state)
    if @order.payment_submitted?
      @order.validate_order = true
      if @order.update(order_params)
        @order.ip_address = request.remote_ip
        if @order.purchase
          @transaction = @order.transactions.last
          @order.cart.inventory
          @cart.save
          UserMailer.order_received(@order).deliver
          session[:cart_id] = nil
          session[:progress] = nil
          @order.update(state: @order.next_state(:success))
          render 'success'
        else
          @transaction = @order.transactions.last
          @order.update(state: @order.next_state(:failure))
          render 'failure'
        end
      else
        render 'payment'
      end
    else
      flash[:alert] = 'Sorry, there was a problem submitting your payment details.'
      bad_state_redirect
    end
  end
    
  def destroy
    @order.destroy
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
    
    ADDRESS_ATTRIBUTES = [:id, [:address_type, :first_name, :last_name,
      :address_1, :address_2, :city, :state_code, :post_code, :country,
      :telephone]]

    def order_params
      params.require(:order)
            .permit(:id, :cart_id, :state, :email,
                    :card_type, :card_expires_on, :card_number, :card_verification,
                    :ip_address, :express_token, :accept_terms, :use_billing,
                    :shipping_method, :shipping_cost, :length, :width, :height, :weight, 
                    addresses_attributes: ADDRESS_ATTRIBUTES)
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

    def save_progress
      session[:progress] ||= []
      if !session[:progress].include?(request.path)
        session[:progress] << request.path
      end
    end

    def bad_state_redirect
      if @order.purchased?
        redirect_to products_path and return
      else
        @order.update(state: Order::STATES.first)
        redirect_to addresses_order_path(@order) and return
      end
    end

    def assign_address(type)
      unless @order.addresses.exists?(address_type: type)
        if signed_in?
          address = current_user.addresses.find_by(address_type: type)
          if address
            @order.addresses << address.dup
          else
            @order.addresses.build(address_type: type)
          end
        else
          @order.addresses.build(address_type: type)
        end
      end
    end
    
    def express_options
      options = {}
      options[:ip] = request.remote_ip,
      options[:return_url] = create_express_orders_url,
      options[:cancel_return_url] = cart_url(@cart),
      options[:payment_action] = 'sale',
      options[:currency] = 'USD',
      options[:brand_name] = 'Seventh Circle Audio',
      options[:allow_guest_checkout] = 'true'
      options[:subtotal] = @cart.subtotal
      options[:items] = @cart.line_items.map do |line_item|
        {
          name: line_item.model,
          description: line_item.product.category + ', ' + line_item.option.description,
          quantity: line_item.quantity,
          amount: line_item.price
        }
      end

      if (discount = @cart.discount) > 0
        options[:items] << { name: 'Discount', quantity: 1, amount: -discount }
      end

      return options
    end

    def use_billing_for_shipping?
      order_params[:use_billing] == 'yes'
    end

    def billing_address_record?
      @order.addresses.exists?(address_type: 'billing')
    end

    def shipping_address_record?
      @order.addresses.exists?(address_type: 'shipping')
    end

    def copy_billing_to_shipping
      billing = params[:order][:addresses_attributes]['0'].dup
      billing[:address_type] = 'billing'
      if billing_address_record?
        billing[:id] = @order.addresses.find_by(address_type: 'billing').id
      else
        billing[:id] = nil
      end

      shipping = billing.dup
      shipping[:address_type] = 'shipping'
      if shipping_address_record?
        shipping[:id] = @order.addresses.find_by(address_type: 'shipping').id
      else
        shipping[:id] = nil
      end

      params[:order][:addresses_attributes]['0'] = billing
      params[:order][:addresses_attributes]['1'] = shipping
    end

    def set_no_cache
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
end
