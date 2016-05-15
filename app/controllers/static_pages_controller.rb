class StaticPagesController < ApplicationController
  
  include ProductUtilities
  
  before_action :set_cart, :set_products

  def admin  
  end
  
  def home
    @slider_images = SliderImage.order(:id)
  end
  
  def forums
  end

  def reviews
  end

  def support
    render "static_pages/tips"
  end

  def contact
  end

  def repairs
  end

  def resources
  end

  def tips
  end

  def troubleshooting
  end
  
end
