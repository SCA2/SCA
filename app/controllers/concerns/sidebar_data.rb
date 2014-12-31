module SidebarData
  
  extend ActiveSupport::Concern
  
  private

    def set_products
      @products = Product.order(:category_sort_order, :model_sort_order)
      @product_categories = Product.order(:category_sort_order).select(:category, :category_sort_order).distinct
      @product_categories = @product_categories.map do |pc|
        count = @products.where(category: pc.category).count
        [pc.category, pc.category.pluralize(count)]
      end
    end 

end