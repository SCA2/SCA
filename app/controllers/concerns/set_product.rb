module SetProduct
  
  extend ActiveSupport::Concern
  
  private

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
    
    def find_product
      product_models = %w(a12b a12 c84 j99b j99 n72 t15 b16 d11 ch02-sp ch02 pc01)
      product_models.each do |model|
        if params[:id].downcase.include? model
          return get_product model
        end
      end
      get_product params[:id].downcase
    end

    def get_product_id(model)
      Product.where("lower(model) = ?", model.downcase).first.id
    end

    def get_product(model)
      Product.where("lower(model) = ?", model.downcase).first
    end

end
