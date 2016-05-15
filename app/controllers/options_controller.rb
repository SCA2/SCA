class OptionsController < ApplicationController

  include ProductUtilities

  before_action :set_cart, :set_products
  
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
      params.require(:option).permit( :model, :options, :description, :price, :discount, :upc, :active,
                                      :shipping_weight, :shipping_length, :shipping_width, :shipping_height,
                                      :assembled_stock, :partial_stock, :component_stock, :sort_order)
    end
    
end
