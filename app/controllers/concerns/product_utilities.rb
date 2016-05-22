module ProductUtilities
  
  extend ActiveSupport::Concern
  
  private

    def set_cart
      @cart = Cart.find(session[:cart_id])
      raise ActiveRecord::RecordNotFound if @cart.purchased_at
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
      session.delete(:progess) if session[:progress]
      session[:progress] = cart_path(@cart)
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

end
