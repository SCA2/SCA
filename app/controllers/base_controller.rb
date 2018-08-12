class BaseController < ApplicationController
    
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
    @product_categories ||= get_product_categories
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
    Product.order(:sort_order)
  end

  def get_product(model)
    Product.where("upper(model) = ?", model.upcase).first
  end

  def get_product_categories
    categories = ProductCategory.order(:sort_order)
    product_counts = Product.where(active: true)
      .group(:product_category_id)
      .count
    categories.reduce([]) do |categories, category|
      count = product_counts[category.id]
      if count || signed_in_admin?
        categories.push [category.id, category.name.pluralize(count || 1)]
      else
        categories
      end
    end
  end

end
