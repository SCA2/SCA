class ErrorPagesController < ApplicationController
  
  def unknown  
    render_404
  end

private

  def render_404(exception = nil)

    logger.info "Rendering 404: #{exception.message}" if exception
    
    render file: "#{Rails.root}/public/404.html", status: 404, layout:false

  end
end