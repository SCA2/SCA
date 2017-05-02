class CartsController < BaseController
  
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  
  def show
    redirect_to products_url, notice: 'Your cart is empty!' if cart.line_items.empty?
  end

  def update
    if cart.id == session[:cart_id]
      if cart.update(cart_params)
        redirect_to cart, notice: 'Cart updated!'
      else
        redirect_to cart, alert: 'Cart not updated!'
      end
    end
  end

  def destroy
    if cart.id == session[:cart_id]
      cart.order.destroy if cart.order
      cart.destroy
    end
    session[:cart_id] = nil
    session[:progress] = []
    redirect_to products_url, notice: 'Your cart is empty!'
  end
  
  def new_invoice
    @customer = InvoiceValidator.new
    @cart = cart
  end

  def create_invoice
    if cart.id == session[:cart_id]
      @customer = InvoiceValidator.new(customer_params)
      if @customer.valid?
        logger.debug "Mailer: " + @customer.inspect
        cart.send_invoice(customer: @customer)
        cart.save!
        session[:cart_id] = nil
        flash[:success] = 'Invoice sent'
        redirect_to products_path
      else
        render 'new_invoice'
      end
    end
  end

  def show_invoice
    @cart = Cart.find_by_invoice_token!(params[:id])
    if @cart.invoice_sent_at < 30.days.ago
      flash[:alert] = 'Your invoice link has expired. Please contact sales@seventhcircleaudio.com for help.'
      redirect_to new_password_reset_path
    elsif @cart.purchased?
      flash[:alert] = 'That invoice has already been paid.'
      redirect_to root_url
    elsif @cart.update_attribute(:invoice_retrieved_at, DateTime.current)
      session[:cart_id] = @cart.id
      redirect_to cart_path(@cart)
    else
      flash[:alert] = 'Sorry, we had a problem retrieving your invoice.'
      redirect_to root_url
    end
  rescue
    redirect_to root_url
  end

  private
  
    def cart_params
      params.require(:cart).permit(:id, line_items_attributes: [:id, :quantity, :_destroy])
    end
    
    def customer_params
      params.require(:cart).require(:invoice_validator).permit(:name, :email)
    end
    
    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to products_url, notice: 'Invalid cart!'
    end
end
