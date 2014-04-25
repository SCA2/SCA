class StaticPagesController < ApplicationController
  
  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  def home
    @slider_images = SliderImage.order(:id)
  end
  
  def forums
  end

  def reviews
  end

  def support
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
