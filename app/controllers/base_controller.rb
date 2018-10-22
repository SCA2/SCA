class BaseController < ApplicationController

  before_action :products
      
  helper_method :cart, :order, :products, :product_categories, :option_path

  def cart
    @cart ||= get_cart
  end

  def order
    @order ||= get_order
  end
  
  def products
    @products ||= get_products
  end 

  def product_categories
    @product_categories ||= ProductCategory.sorted
  end 

private

  def option_path(option)
    product_path(option.product)
  end

  def get_cart
    cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    session[:progress] = [cart_path(cart)]
    cart
  end

  def get_order
    Order.find_or_create_by(cart_id: cart.id)
  end

  def get_products
    if signed_in_admin?
      Product.sorted
    else
      Product.active
    end
  end

  def get_product(model)
    Product.where("upper(model) = ?", model.upcase).first
  end
end
