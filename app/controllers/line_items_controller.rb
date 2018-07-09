class LineItemsController < BaseController
  
  def create
    product = get_product(params.require(:product_id))
    option = Option.find(params.require(:option_id))
    line_item = cart.add_product(product, option)
    respond_to do |format|
      if line_item.save
        format.html { redirect_to products_path }
        format.js { render layout: false }
      else
        raise Exception.new
      end
    end
  rescue
    flash[:alert] = 'Sorry, there was a problem with the cart.'
    redirect_to products_path
  end
  
end