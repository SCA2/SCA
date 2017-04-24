module Checkout
  class CheckoutController < BaseController

  private
    
    def empty_cart_redirect
      if cart.line_items_empty?
        flash[:notice] = 'Your cart is empty'
        redirect_to products_path and return
      end
    end

    def cart_purchased_redirect
      if cart.purchased?
        flash[:notice] = 'Cart already purchased'
        redirect_to products_path and return
      end
    end

    def set_no_cache
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end

    def save_progress
      # session[:progress] ||= []
      if !session[:progress].include?(request.path)
        session[:progress] << request.path
      end
    end

  end
end
