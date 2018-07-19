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
    Product.where("upper(model) = ?", model.upcase).first
  end

  def find_product
    models = Product.select(:model).order(:model).pluck(:model)
    models.each do |model|
      if params[:id].upcase.include? model.upcase
        return get_product(model)
      end
    end
    return nil
  end

  def get_product_categories
    categories = ProductCategory.order(:sort_order)
    product_counts = Product.where(active: true)
      .group(:product_category_id)
      .count
    categories.reduce([]) do |cats, category|
      count = product_counts[category.id]
      if count || signed_in_admin?
        cats.push [category.id, category.name.pluralize(count || 1)]
      else
        cats
      end
    end
  end

end
