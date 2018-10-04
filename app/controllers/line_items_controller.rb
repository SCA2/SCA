class LineItemsController < BaseController
  
  def create
    line_item = cart.add_item(params.permit(:component_id))
    respond_to do |format|
      if line_item.save!
        format.html { redirect_to products_path }
        format.js { render layout: false }
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "#{e.message}"
    redirect_to products_path
  end
end