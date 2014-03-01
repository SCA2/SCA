class FeaturesController < ApplicationController

  before_action :signed_in_admin, except: :show
  before_action :set_feature, only: [:show, :edit, :update, :destroy]

  # GET /features
#  def index
    #@features = Feature.all
#  end

  # GET /features/1
  def show
  end

  # GET /features/new
  def new
    @product = Product.find(params[:product_id])
    @feature = @product.features.build
  end


  # GET /features/1/edit
  def edit
  end

  # POST /features
  def create
    @product = Product.find(params[:feature][:product_id])
    @feature = @product.features.build(feature_params)

    if @feature.save
      redirect_to @product, notice: 'Feature was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /features/1
  def update
    if @feature.update(feature_params)
      redirect_to @product, notice: 'Feature was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /features/1
  def destroy
    @feature.destroy
    redirect_to @product
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @product = Product.find(params[:product_id])
      @feature = @product.features.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params.require(:feature).permit(:model, :caption, :sort_order, :description)
    end
    
end
