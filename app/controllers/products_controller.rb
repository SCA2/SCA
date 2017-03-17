class ProductsController < BaseController
  
  before_action :delete_orphans, only: [:index]
  before_action :signed_in_admin, except: [:index, :show, :update_option]
  before_action :set_product, only: [:show, :edit, :update, :update_option, :destroy]

  def index
    # @products = Product.order(:category_sort_order, :model_sort_order)
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
      format.js
    end
  end

  def destroy
    @product.destroy
    flash[:notice] = "Success! Product #{@product.model} deleted."
    redirect_to products_path
  rescue(ActiveRecord::InvalidForeignKey)
    carts = @product.line_items.map {|line| line.cart }
    orders = carts.map {|cart| cart.order }
    if carts.count > 0 && !orders.first
      alert = "Product #{@product.model} is referenced by cart #{carts.first.id} and #{carts.count - 1} others. Delete those first."
    else
      alert = "Product #{@product.model} is referenced by order #{orders.first.id} and #{orders.count - 1} others. Delete those first."
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
      :model, :model_sort_order, :options,
      :short_description, :long_description, :notes,
      :image_1, :image_2, :specifications,
      :bom, :schematic, :assembly)
  end

  def set_product
    @product = find_product
    redirect_to products_path and return if @product.nil?
    if @product.options.any?
      @option = view_context.get_current_option(@product)
    else
      flash[:alert] = 'Product must have at least one option!'
      redirect_to new_product_option_path(@product)
    end
  end

  def find_product
    if products && params[:id]
      product_models = products.select(:model).to_ary
      product_models = product_models.sort_by { |record| record.model.length }
      product_models = product_models.reverse.map { |record| record.model.downcase }
      product_models.each do |model|
        if params[:id].downcase.include? model
          return get_product(model)
        end
      end
    end
    return nil
  end

  def delete_orphans
    Product.delete_products_without_options if signed_in_admin?
  end

end
