module CurrentCart
  
  extend ActiveSupport::Concern
  
  private

    def set_cart
      @cart = Cart.find(session[:cart_id])
      if @cart.purchased_at
        raise ActiveRecord::RecordNotFound
      end
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
      session.delete(:progess) if session[:progress]
      session[:progress] = cart_path(@cart)
    end

end
