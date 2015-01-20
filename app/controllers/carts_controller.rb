class CartsController < ApplicationController
  
  include CurrentCart
  include SidebarData
  
  before_action :set_products
  before_action :signed_in_admin, except: [:show, :update, :destroy]
  before_action :set_cart, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  
  def show
    redirect_to products_url, notice: 'Your cart is empty!' if @cart.line_items.empty?
  end

  def update
    if @cart.id == session[:cart_id]
      if @cart.update(cart_params)
        redirect_to @cart, notice: 'Cart updated!'
      else
        redirect_to products_url
      end
    end
  end

  def destroy
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    session[:progress] = nil
    redirect_to products_url, notice: 'Your cart is empty!'
  end
  
  private
  
    def cart_params
      params.require(:cart).permit(:id, line_items_attributes: [:id, :quantity, :_destroy])
    end
    
    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to products_url, notice: 'Invalid cart!'
    end
end
