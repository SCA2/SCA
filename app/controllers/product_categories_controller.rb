class ProductCategoriesController < BaseController
  
  before_action :signed_in_admin
  before_action :set_product_category, only: [:edit, :update, :destroy]

  def index
    @categories = ProductCategory.order(:sort_order)
  end

  def new
    @category = ProductCategory.new
  end

  def edit
  end

  def create
    @category = ProductCategory.new(category_params)
    if @category.save
      flash[:success] = "Success! Product Category #{@category.name} created."
      redirect_to product_categories_path
    else
      render 'new'
    end
  end

  def update
    if @category.update(category_params)
      flash[:success] = "Success! Product Category #{@category.name} updated."
      redirect_to product_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    flash[:error] = @category.errors.full_messages.join('\n') unless @category.destroy
    redirect_to product_categories_path
  end

  private

    def set_product_category
      @category = ProductCategory.find(params[:id])
    end

    def category_params
      params.require(:product_category).permit(:id, :name, :sort_order)
    end
    
end
