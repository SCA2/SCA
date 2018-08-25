class OrdersController < BaseController

  before_action :admin_user

  def index
    @orders = Order.checked_out.order(created_at: :asc).distinct
  end
  
  def show
    @order = Order.find(order_params)
    @cart = @order.cart
    @billing = @order.billing_address
    @shipping = @order.shipping_address

    if @order.invalid? || @billing.nil? || @shipping.nil? || @cart.nil?
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
    orders = Order.abandoned
    orders.each { |order| order.destroy }
    redirect_to orders_path
  end

  def search
    start = params[:from].to_date.beginning_of_day
    stop = params[:to].to_date.end_of_day
    time_range = start..stop
    @orders = Order.checked_out.where(carts: { purchased_at: time_range })
    render 'index'
  end

  def sales_tax
    start = params[:from].to_date.beginning_of_day
    stop = params[:to].to_date.end_of_day
    @tax = SalesTaxCalculator.new(start..stop)
  end

  def get_tracking_number
    @order = Order.find(order_params)
    @cart = @order.cart
    @billing = @order.billing_address
    @shipping = @order.shipping_address
    @transaction = @order.transactions.last
  end

  def packing_slip
    @order = Order.find(order_params)
    @cart = @order.cart
    @billing = @order.billing_address
    @shipping = @order.shipping_address
    flash.now[:success] = 'Packing slip printed'
  end

  def send_tracking_number
    @order = Order.find(order_params)
    @cart = @order.cart
    @billing = @order.billing_address
    @shipping = @order.shipping_address
    @transaction = @order.transactions.last
    if @transaction.update(
      tracking_number: transaction_params,
      shipped_at: DateTime.current.in_time_zone
    )
      UserMailer.order_shipped(@order).deliver
      flash.now[:success] = 'Tracking number sent!'
      @orders = Order.shipped
      render 'index'
    else
      render 'get_tracking_number'
    end
  end

  def successful
    @orders = Order.successful.order(created_at: :asc).distinct
    render 'index'
  end

  def failed
    @orders = Order.failed.order(created_at: :asc).distinct
    render 'index'
  end

  def pending
    @orders = Order.pending.order(created_at: :asc).distinct
    render 'index'
  end

  def shipped
    @orders = Order.shipped.order(created_at: :asc).distinct
    render 'index'
  end

  def abandoned
    @orders = Order.abandoned.order(created_at: :asc)
    render 'index'
  end

private

  def order_params
    params.require(:id)
  end

  def transaction_params
    params.require(:transaction).permit(:tracking_number)[:tracking_number]
  rescue ActionController::ParameterMissing
    ''
  end

  def admin_user
    unless signed_in_admin?
      flash[:alert] = 'Sorry, admins only'
      redirect_to(home_path)
    end
  end

end
