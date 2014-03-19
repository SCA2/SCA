class ProductsController < ApplicationController
  
  include CurrentCart, SidebarData
  before_action :set_cart, :set_products

  before_action :signed_in_admin, except: [:index, :show, :update_option]
  before_action :set_product, only: [:show, :edit, :update, :update_option, :destroy]

  # GET /products
  def index
    @products = Product.order(:category_sort_order, :model_sort_order)
#    logger.debug '@products: ' + @products.inspect
  end

  # GET /products/1
  def show
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

  # PATCH/PUT /products/1
  def update_option
    if @product.update(product_option_params)
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
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
      params.require(:product).permit(:model, :model_sort_order,
      :category, :category_sort_order, :current_option,
      :short_description, :long_description, :notes,
      :image_1, :image_2, 
      :specifications, :bom, :schematic, :assembly)
    end

    def product_option_params
      params.require(:product).permit(:current_option)
    end

end
