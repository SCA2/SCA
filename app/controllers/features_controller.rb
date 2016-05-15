class FeaturesController < ApplicationController

  include ProductUtilities

  before_action :set_cart, :set_products  
  before_action :signed_in_admin
  before_action :set_feature, only: [:edit, :update, :destroy]

  def new
    @product = get_product(params[:product_id])
    @feature = Feature.next_feature
  end

  def edit
  end

  def create
    @product = get_product(params[:product_id])
    @feature = @product.features.build(feature_params)
    if @feature.save
      flash[:success] = "Success! Feature #{ @feature.sort_order } created."
      redirect_to new_product_feature_path
    else
      render action: 'new'
    end
  end

  def update
    if @feature.update(feature_params)
      flash[:success] = "Success! Feature #{ @feature.sort_order } updated."
      redirect_to @product
    else
      render action: 'edit'
    end
  end

  def destroy
    id = @feature.id
    @feature.destroy
    flash[:success] = "Success! Feature #{ id } deleted."
    redirect_to @product
  end

  private
    def set_feature
      @product = get_product(params[:product_id])
      @feature = @product.features.find(params[:id])
    end

    def feature_params
      params.require(:feature).permit(:caption, :sort_order, :description)
    end
    
end
