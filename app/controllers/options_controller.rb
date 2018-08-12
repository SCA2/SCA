class OptionsController < BaseController

  before_action :signed_in_admin
  before_action :set_option, only: [:edit, :update, :destroy]

  def new
    @option_editor = OptionEditor.new(all_params)
  end


  def edit
    @option_editor = OptionEditor.new(all_params)
  end

  def create
    @option_editor = OptionEditor.new(all_params)
    handle_inventory if @option_editor.valid?
    if @option_editor.save
      flash[:notice] = "Success! Option #{ @option_editor.option_model } created."
      redirect_to edit_bom_path(@option_editor.bom)
    else
      render action: 'new'
    end
  end

  def update
    @option_editor = OptionEditor.new(all_params)
    handle_inventory if @option_editor.valid?
    if @option_editor.save
      flash[:notice] = "Success! Option #{ @option_editor.option_model } updated."
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
  def handle_inventory
    inv_calc = InventoryCalculator.new(option: @option_editor.option)
    inv_calc.make_kits(quantity: @option_editor.kits_to_make)
    inv_calc.make_partials(quantity: @option_editor.partials_to_make)
    inv_calc.make_assemblies(quantity: @option_editor.assembled_to_make)
  end

  def set_option
    @product = get_product(params[:product_id])
    if @product.options.any?
      @option = view_context.get_current_option(@product)
    else
      flash[:alert] = 'Product must have at least one option!'
      redirect_to new_product_option_path(@product)
    end
  end

  def all_params
    params.permit(:id, :product_id, option_editor: [:model, :description, :price, :discount, :upc, :active, :sort_order, :shipping_weight, :shipping_length, :shipping_width, :shipping_height, :assembled_stock, :kit_stock, :partial_stock, :kits_to_make, :partials_to_make, :assembled_to_make])
  end


end
