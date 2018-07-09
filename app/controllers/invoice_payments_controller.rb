class InvoicePaymentsController < BaseController

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  def show
    @invoice = Cart.find_by_invoice_token!(params.require(:id))
    if @invoice.invoice_sent_at < 30.days.ago
      flash[:alert] = 'Your invoice link has expired. Please email sales@seventhcircleaudio.com for help.'
      redirect_to root_url
    elsif @invoice.purchased?
      flash[:alert] = 'That invoice has already been paid. Please email sales@seventhcircleaudio.com for help.'
      redirect_to root_url
    elsif @invoice.update_attribute(:invoice_retrieved_at, DateTime.current)
      session[:cart_id] = @invoice.id
      redirect_to cart_path(@invoice)
    else
      invalid_cart
    end
  end

private

  def invalid_cart
    logger.error "Attempt to access invalid invoice cart #{params[:id]}"
    flash[:alert] = 'Sorry, we had a problem retrieving your invoice. Please email sales@seventhcircleaudio.com for help.'
    redirect_to root_url
  end
    
end
