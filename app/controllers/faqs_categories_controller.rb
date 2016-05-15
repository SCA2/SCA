class FaqsCategoriesController < ApplicationController
  
  include ProductUtilities

  before_action :set_cart, :set_products
  before_action :signed_in_admin
  before_action :set_faqs_category, only: [:edit, :update, :destroy]

  def index
    @faqs_categories = FaqsCategory.order(:category_weight)
  end

  def new
    @faqs_category = FaqsCategory.new
  end

  def edit
  end

  def create
    @faqs_category = FaqsCategory.new(category_params)
    if @faqs_category.save
      flash[:success] = "Success! Faq Category #{@faqs_category.category_name} created."
      redirect_to faqs_categories_path
    else
      render 'new'
    end
  end

  def update
    if @faqs_category.update(category_params)
      flash[:success] = "Success! Faq Category #{@faqs_category.category_name} updated."
      redirect_to faqs_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    flash[:error] = @faqs_category.errors.full_messages.join('\n') unless @faqs_category.destroy
    redirect_to faqs_categories_path
  end

  private

    def set_faqs_category
      @faqs_category = FaqsCategory.find(params[:id])
    end

    def category_params
      params.require(:faqs_category).permit(:faq_id, :category_name, :category_weight)
    end
    
end
