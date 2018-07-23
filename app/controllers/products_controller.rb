class ProductsController < BaseController
  before_action :delete_orphans, only: [:index]
  before_action :signed_in_admin, except: [:index, :show, :update_option]
  before_action :set_product, only: [:show, :edit, :update, :update_option, :destroy]

  def index
    @products = Product.joins(:product_category).order(:product_category_id, :model_sort_order)
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
    flash[:notice] = "Success! Product #{@product.model} deleted."
    redirect_to products_path
  rescue(ActiveRecord::InvalidForeignKey)
    carts = Cart.joins(:line_items).where(id: LineItem.joins(:option).
      where(option_id: Option.where(product_id: @product.id)))
    orders = Order.joins(:cart).where(cart_id: carts)
    if orders.count > 0
      alert = "Product #{@product.model} is referenced by order #{orders.first.id} and #{orders.count - 1} others. Delete those first."
    elsif carts.count > 0
      alert = "Product #{@product.model} is referenced by cart #{carts.first.id} and #{carts.count - 1} others. Delete those first."
    else
      alert = "Can't delete this product because of invalid foreign key."
    end
    redirect_to products_path, alert: alert
  end

  def update_category_sort_order
    order = Product.get_category_sort_order(params[:category])
    render json: order.to_json
  end

private

  def product_params
    params.require(:product).permit(:product_category_id, 
      :model, :model_sort_order, :options, :active,
      :short_description, :long_description, :notes,
      :image_1, :image_2, :specifications,
      :bom, :schematic, :assembly)
  end

  def set_product
    @product = find_product
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
