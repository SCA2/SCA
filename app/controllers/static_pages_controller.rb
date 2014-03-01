class StaticPagesController < ApplicationController
  
  before_action :set_products
  
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

  def cart
  end
  
  private
  
    def set_products
      @products = Product.order(:category_weight, :model_weight)
    end

end
