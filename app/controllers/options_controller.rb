class OptionsController < BaseController

  before_action :signed_in_admin
  before_action :set_option, only: [:edit, :update, :destroy]

  def new
    @product = get_product(params[:product_id])
    @option = Option.new(product: get_product(params[:product_id]))
  end


  def edit
  end

  def create
    @product = get_product(params[:product_id])
    @option = @product.options.build(option_params)

    if @option.save
      flash[:notice] = "Success! Option #{ @option.model } created."
      redirect_to new_product_option_path(@product)
    else
      render action: 'new'
    end
  end

  def update
    if @option.update(option_params)
      if @option.is_a_kit?
        @option.make_kits(option_params[:kits_to_make])
      else
        @option.make_partials(option_params[:partials_to_make])
        @option.make_assembled(option_params[:assembled_to_make])
      end
      flash[:notice] = "Success! Option #{ @option.model } updated."
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

    def option_params
      params.
      require(:option).
      permit(:model, :options, :description, :price, :discount, :upc, :active, :sort_order,
        :shipping_weight, :shipping_length, :shipping_width, :shipping_height,
        :kit_stock, :partial_stock, :assembled_stock,
        :kits_to_make, :partials_to_make, :assembled_to_make)
    end
    
end
