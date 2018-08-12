class LineItemsController < BaseController
  
  def create
    line_item = cart.add_item(line_item_params)
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

private

  def line_item_params
    {
      itemizable_id: params.require(:itemizable_id),
      itemizable_type: params.require(:itemizable_type)
    }
  end

end