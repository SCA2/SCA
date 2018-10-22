class ProductsController < BaseController
  before_action :delete_orphans, only: [:index]
  before_action :signed_in_admin, except: [:index, :show, :update_option]
  before_action :set_product, only: [:show, :edit, :update, :update_option, :destroy]

  def index
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
      format.js { render layout: false }
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Success! Product deleted."
  rescue => e
    redirect_to products_path, alert: e.message
  end

  def update_category_sort_order
    order = Product.get_category_sort_order(params[:category])
    render json: order.to_json
  end

private

  def product_params
    params.require(:product).permit(
      :product_category_id, :display_category_id, 
      :model, :sort_order, :options, :active,
      :short_description, :long_description, :notes,
      :image_1, :image_2, :specifications,
      :bom, :schematic, :assembly)
  end

  def set_product
    @product = get_product(params[:id])
    if @product.nil?
      flash[:alert] = "Can't find that product!"
      redirect_to products_path
    elsif @product.options.any?
      @option = view_context.get_current_option(@product)
    else
      flash[:alert] = 'Product must have at least one option!'
      redirect_to new_product_option_path(@product)
    end
  end

  def delete_orphans
    Product.delete_products_without_options if signed_in_admin?
  end

end
