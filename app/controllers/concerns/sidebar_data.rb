module SidebarData
  
  extend ActiveSupport::Concern
  
  private

    def set_products
      @products = Product.order(:category_sort_order, :model_sort_order)
    end 

end