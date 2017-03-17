class FaqsCategoriesController < BaseController
  
  before_action :signed_in_admin
  before_action :set_faqs_category, only: [:edit, :update, :destroy]

  def index
    @categories = FaqsCategory.order(:category_weight)
  end

  def new
    @category = FaqsCategory.new
  end

  def edit
  end

  def create
    @category = FaqsCategory.new(category_params)
    if @category.save
      flash[:success] = "Success! FAQs Category #{@category.category_name} created."
      redirect_to faqs_categories_path
    else
      render 'new'
    end
  end

  def update
    if @category.update(category_params)
      flash[:success] = "Success! FAQs Category #{@category.category_name} updated."
      redirect_to faqs_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    flash[:error] = @category.errors.full_messages.join('\n') unless @category.destroy
    redirect_to faqs_categories_path
  end

  private

    def set_faqs_category
      @category = FaqsCategory.find(params[:id])
    end

    def category_params
      params.require(:faqs_category).permit(:faq_id, :category_name, :category_weight)
    end
    
end
