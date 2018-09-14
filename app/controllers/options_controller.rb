class OptionsController < BaseController

  before_action :signed_in_admin
  before_action :set_product_and_options
  before_action :set_option, only: [:edit, :update, :destroy]

  def new
    @components = Component.priced
      .left_outer_joins(:option)
      .where.not(options: { id: @options })
    if @components.empty?
      flash[:alert] = 'Create some components!'
      redirect_to products_path
    end
    next_sort_order = @options.last ? @options.last.sort_order + 10 : 10
    @option = Option.new(sort_order: next_sort_order)
    @component = @components.first
  end

  def create
    @option = @product.options.build(option_params)
    if @option.save
      flash[:notice] = "Success! Option #{ @option.component.item_model } created."
      redirect_to @product
    else
      render action: 'new'
    end
  end

  def update
    @option.update(option_params)
    if @option.save
      flash[:notice] = "Success! Option #{ @option.component.item_model } updated."
      redirect_to @product
    else
      render action: 'edit'
    end
  end

  def destroy
    @option.destroy
    flash[:notice] = "Success! Option #{@option.id} deleted."
    redirect_to @product
  rescue(ActiveRecord::DeleteRestrictionError)
    carts = Cart.where(id: LineItem.where(itemizable_id: @option.id).pluck(:cart_id))
    orders = Order.joins(:cart).where(cart_id: carts)
    if orders.count > 0
      alert = "Option #{@option.model} is referenced by order #{orders.first.id} and #{orders.count - 1} others. Delete those first."
    elsif carts.count > 0
      alert = "Option #{@option.model} is referenced by cart #{carts.first.id} and #{carts.count - 1} others. Delete those first."
    else
      alert = "Can't delete this option because of invalid foreign key."
    end
    redirect_to @product, alert: alert
  end

private

  def set_product_and_options
    @product = get_product(params[:product_id])
    @options = @product.options.sorted
  end
  
  def set_option
    @option = Option.find(params.require(:id))
    unless @option
      flash[:alert] = 'Product must have at least one option!'
      redirect_to new_product_option_path(@product)
    end
  end

  def option_params
    params.require(:option).permit(:active, :sort_order, :component_id)
  end

end
