class OptionsController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :signed_in_admin
  before_action :set_option, only: [:edit, :update, :destroy]

  def new
    @product = Product.find(params[:product_id])
    @option = @product.options.build
  end


  def edit
  end

  def create
    @product = Product.find(params[:product_id])
    @option = @product.options.build(option_params)

    if @option.save
      redirect_to @product, notice: 'Option was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @option.update(option_params)
      redirect_to @product, notice: 'Option was successfully updated.'
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
      @product = Product.find(params[:product_id])
      if @product.options.any?
        @option = Option.find(get_current_option(@product))
      else
        flash[:notice] = 'Product must have at least one option!'
        redirect_to new_product_option_path(@product)
      end
    end

    def option_params
      params.require(:option).permit( :model, :current_option, :description, :price, :discount, :upc,
                                      :shipping_weight, :shipping_length, :shipping_width, :shipping_height,
                                      :assembled_stock, :partial_stock, :kit_stock, :part_stock, :sort_order)
    end
    
end
