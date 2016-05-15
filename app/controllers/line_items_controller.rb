class LineItemsController < ApplicationController
  
  include ProductUtilities
  
  def create
    set_cart
    product = get_product(line_item_params[:product_id])
    option = Option.find(line_item_params[:option_id])
    @line_item = @cart.add_product(product, option)
    
    respond_to do |format|
      if @line_item.save
        set_cart
        format.html { redirect_to products_path }
        format.js
      else
        raise Exception.new
      end
    end
  rescue
    redirect_to products_path, notice: 'Sorry, there was a problem with the cart.'
  end
  
  private
  
    def line_item_params
      params.permit(:line_item, :cart_id, :product_id, :option_id, :quantity)
    end
    
end