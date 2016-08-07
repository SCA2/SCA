class BaseController < ApplicationController
    
  helper_method :cart, :order, :products, :product_categories

  def cart
    @cart ||= get_cart
  end

  def order
    @order ||= cart.order
  end
  
  def products
    @products ||= get_products
  end 

  def product_categories
    @product_categories ||= get_product_categories
  end 

private

  def get_cart
    cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    session.delete(:progess) if session[:progress]
    session[:progress] = cart_path(cart)
    cart
  end

  def get_products
    Product.order(:category_sort_order, :model_sort_order)
  end

  def get_product(model)
    Product.where("lower(model) = ?", model.downcase).first
  end

  def get_product_categories
    categories = Product.order(:category_sort_order).select(:category, :category_sort_order).distinct
    categories.map do |pc|
      count = products.where(category: pc.category).count
      [pc.category, pc.category.pluralize(count)]
    end
  end

end
