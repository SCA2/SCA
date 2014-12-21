class FeaturesController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :signed_in_admin
  before_action :set_feature, only: [:edit, :update, :destroy]

  def new
    @product = Product.find(params[:product_id])
    @feature = Feature.next_feature
  end

  def edit
  end

  def create
    @product = Product.find(params[:product_id])
    @feature = @product.features.build(feature_params)
    if @feature.save
      redirect_to @product, notice: 'Feature was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @feature.update(feature_params)
      redirect_to @product, notice: 'Feature was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @feature.destroy
    redirect_to @product
  end

  private
    def set_feature
      @product = Product.find(params[:product_id])
      @feature = @product.features.find(params[:id])
    end

    def feature_params
      params.require(:feature).permit(:model, :caption, :sort_order, :description)
    end
    
end
