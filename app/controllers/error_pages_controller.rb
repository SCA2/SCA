class ErrorPagesController < ApplicationController
  
  include ProductUtilities

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
end