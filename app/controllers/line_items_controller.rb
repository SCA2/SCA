class LineItemsController < BaseController
  
  def create
    product = get_product(line_item_params[:product_id])
    option = Option.find(line_item_params[:option_id])
    line_item = cart.add_product(product, option)
    
    respond_to do |format|
      if line_item.save
        format.html { redirect_to products_path }
        format.js
      else
        raise Exception.new
      end
    end
  rescue
    flash[:alert] = 'Sorry, there was a problem with the cart.'
    redirect_to products_path
  end
  
  private
  
    def line_item_params
      params.permit(:line_item, :cart_id, :product_id, :option_id, :quantity)
    end
    
end