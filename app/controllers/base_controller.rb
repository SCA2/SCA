class BaseController < ApplicationController
    
  helper_method :cart, :order, :products, :product_categories

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
    @product_categories ||= get_product_categories
  end 

private

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
    Product.order(:category_sort_order, :model_sort_order)
  end

  def get_product(model)
    Product.where("lower(model) = ?", model.downcase).first
  end

  def get_product_categories
    categories = ProductCategory.all.order(:sort_order)
    categories.map do |category|
      count = ProductCategory.includes(:products).where(id: category).count
      [category.id, category.name.pluralize(count)]
    end
  end

end
