class ProductsController < ApplicationController
  
  before_action :signed_in_admin, except: [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  def index
    @category = Product.select(:category).distinct.order(:category_weight)
    @products = Product.order(:model_weight)
    respond_to do |format|
      format.html
      format.csv { render text: @faqs.to_csv }
    end
  end

  # GET /products/1
  def show
    @products = Product.order(:category_weight, :model_weight)
    @features = @product.features.order(:caption_sort_order)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:model, :model_weight, :category, :category_weight, 
      :upc, :price, :short_description, :long_description, :notes, :image_1, :image_2)
    end

end
