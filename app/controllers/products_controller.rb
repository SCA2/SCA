class ProductsController < ApplicationController
  
  include CurrentCart, SidebarData, SetProduct

  before_action :set_cart, :set_products

  before_action :signed_in_admin, except: [:index, :show, :update_option]
  before_action :set_product, only: [:show, :edit, :update, :update_option, :destroy]

  def index
    @products = Product.order(:category_sort_order, :model_sort_order)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "Success! Product #{@product.model} created."
      redirect_to @product
    else
      render action: 'new'
    end
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Success! Product #{@product.model} updated."
      redirect_to @product
    else
      render action: 'edit'
    end
  end

  def update_option
    @option = view_context.set_current_option(@product, product_params)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    id = @product.id
    @product.destroy
    flash[:notice] = "Success! Product #{id} deleted."
    redirect_to products_path
  end

  private

    # def set_product
    #   @product = find_product
    #   redirect_to products_path and return if @product.nil?
    #   if @product.options.any?
    #     @option = view_context.get_current_option(@product)
    #   else
    #     flash[:alert] = 'Product must have at least one option!'
    #     redirect_to new_product_option_path(@product)
    #   end
    # end
    
    # def find_product
    #   product_models = %w(a12b a12 c84 j99b j99 n72 t15 b16 d11 ch02 pc01)
    #   product_models.each do |model|
    #     if params[:id].downcase.include? model
    #       return Product.where("lower(model) = ?", model).first
    #     end
    #   end
    #   Product.where("lower(model) = ?", params[:id].downcase).first
    # end

    def product_params
      params.require(:product).permit(:model, :model_sort_order,
      :category, :category_sort_order, :options,
      :short_description, :long_description, :notes,
      :image_1, :image_2, 
      :specifications, :bom, :schematic, :assembly)
    end

end
