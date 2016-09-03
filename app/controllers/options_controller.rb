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
    if @option_editor.save
      flash[:notice] = "Success! Option #{@option_editor.option_model} created."
      redirect_to new_bom_path(@option_editor.product)
    else
      render action: 'new'
    end
  end

  def update
    @option_editor = OptionEditor.new(all_params)
    if @option_editor.save
      flash[:notice] = "Success! Option #{ @option_editor.option_model } updated."
      redirect_to @product
    else
      render action: 'edit'
    end
  end

  def destroy
    id = @option.id
    @option.destroy
    flash[:notice] = "Success! Option #{id} deleted."
    redirect_to @product
  end

private

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
