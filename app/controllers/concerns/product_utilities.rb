module ProductUtilities
  
  extend ActiveSupport::Concern
  
  private

    def set_cart
      @cart ||= get_cart
      raise ActiveRecord::RecordNotFound if @cart.purchased?
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
      session.delete(:progess) if session[:progress]
      session[:progress] = cart_path(@cart)
    end

    def empty_cart_redirect
      @cart ||= get_cart
      if @cart.empty?
        flash[:notice] = 'Your cart is empty'
        redirect_to products_path and return
      end
    end

    def checkout_complete_redirect
      @cart ||= get_cart
      if @cart.purchased?
        flash[:notice] = 'Cart already purchased'
        redirect_to products_path and return
      end
    end

    def set_product
      @product = find_product
      redirect_to products_path and return if @product.nil?
      if @product.options.any?
        @option = view_context.get_current_option(@product)
      else
        flash[:alert] = 'Product must have at least one option!'
        redirect_to new_product_option_path(@product)
      end
    end
    
    def set_products
      @products ||= get_products
      @product_categories = Product.order(:category_sort_order).select(:category, :category_sort_order).distinct
      @product_categories = @product_categories.map do |pc|
        count = @products.where(category: pc.category).count
        [pc.category, pc.category.pluralize(count)]
      end
    end 

    def find_product
      @products ||= get_products
      if @products && params[:id]
        product_models = @products.select(:model).to_ary
        product_models = product_models.sort_by { |record| record.model.length }
        product_models = product_models.reverse.map { |record| record.model.downcase }
        product_models.each do |model|
          if params[:id].downcase.include? model
            return get_product model
          end
        end
      end
      return nil
    end

    def get_products
      Product.order(:category_sort_order, :model_sort_order)
    end

    def get_product_id(model)
      Product.where("lower(model) = ?", model.downcase).first.id
    end

    def get_product(model)
      Product.where("lower(model) = ?", model.downcase).first
    end

    def get_cart
      Cart.find(session[:cart_id])
    end
    
    def set_no_cache
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end

    def save_progress
      session[:progress] ||= []
      if !session[:progress].include?(request.path)
        session[:progress] << request.path
      end
    end

end
