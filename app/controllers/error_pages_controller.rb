class ErrorPagesController < BaseController
  
  def unknown  
    product = find_product
    if product
      redirect_to product
    else
      render_404
    end
  end

private

  def render_404(exception = nil)
    logger.info "Rendering 404: #{exception.message}" if exception
    render file: "#{Rails.root}/public/404.html", status: 404, layout:false
  end

  def find_product
    if products && params[:id]
      product_models = products.select(:model).to_ary
      product_models = product_models.sort_by { |record| record.model.length }
      product_models = product_models.reverse.map { |record| record.model.downcase }
      product_models.each do |model|
        if params[:id].downcase.include? model
          return get_product model
        end
      end
    end
    return nil
  end

end