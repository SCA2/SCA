class InvoicesController < BaseController

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  before_action :signed_in_admin
  
  def index
    @invoices = Cart.invoices
  end

  def pending
    @invoices = Cart.invoices_pending
    render 'index'
  end

  def paid
    @invoices = Cart.invoices_paid
    render 'index'
  end

  def search
    start = params[:from].to_date.beginning_of_day
    stop = params[:to].to_date.end_of_day
    @invoices = Cart.invoices.where(invoice_sent_at: start..stop)
    render 'index'
  end

  def new
    @customer = CustomerValidator.new
    @invoice = cart
  end

  def edit
    @invoice = Cart.find(invoice_params[:invoice_id])
    @customer = CustomerValidator.new(customer_params)
    render 'new'
  end

  def create
    @invoice = Cart.find(invoice_params[:invoice_id])
    @customer = CustomerValidator.new(customer_params)

    if @customer.valid?
      logger.debug "Mailer: " + @customer.inspect
      @invoice.send_invoice(customer: @customer)
      session[:cart_id] = nil
      redirect_to invoices_path, success: 'Invoice sent'
    else
      render 'new'
    end
  end

  def show
    @invoice = Cart.find(params[:id])
  end

  def destroy
    return if params[:id] == session[:cart_id]
    invoice = Cart.find(params[:id])
    destroy invoice.order if invoice.order
    invoice.destroy
    redirect_to invoices_path, notice: 'Invoice deleted'
  end
  
private
  def invoice_params
    params.require(:cart).permit(:invoice_id)
  end

  def customer_params
    params.require(:cart).require(:customer_validator).permit(:name, :email, :body)
  end

  def invalid_cart
    logger.error "Attempt to access invalid invoice #{invoice_params[:invoice_id]}"
    redirect_to invoices_path, notice: 'Invalid invoice!'
  end

end
