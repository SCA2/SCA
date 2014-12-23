class ProductsController < ApplicationController
  
  include CurrentCart, SidebarData
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
      flash[:notice] = "Success! Product #{@product.id} created."
      redirect_to @product
    else
      render action: 'new'
    end
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Success! Product #{@product.id} updated."
      redirect_to @product
    else
      render action: 'edit'
    end
  end

  def update_option
    # byebug
    set_current_option
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

    def set_current_option
      session[@product.id][:current_option] = product_params[:current_option]
      @product.current_option = session[@product.id][:current_option].to_i
    end
  
    def get_current_option(product)
      option = 0
      begin
        option = session[product.id][:current_option].to_i
      rescue
        session[product.id][:current_option] = 0
        option = session[product.id][:current_option].to_i
      end
      option = product.options.first.id.to_i unless product.options.exists?(option)
      option
    end

    def set_product
      @product = Product.find(params[:id])
      if @product.options.any?
        @product.current_option = get_current_option(@product)
        @option = @product.options.find(@product.current_option)
        session[params[:id]][:current_option] = @option.id
      else
        flash[:notice] = 'Product must have at least one option!'
        redirect_to new_product_option_path(@product)
      end
    end
    
    def product_params
      params.require(:product).permit(:model, :model_sort_order,
      :category, :category_sort_order, :current_option,
      :short_description, :long_description, :notes,
      :image_1, :image_2, 
      :specifications, :bom, :schematic, :assembly)
    end

end
