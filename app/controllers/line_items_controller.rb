class LineItemsController < ApplicationController
  
  include CurrentCart
  
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @line_items = LineItem.all
  end

  def show
  end

  def new
    @line_item = LineItem.new
  end

  def edit
  end

  def create
    product = Product.find(params[:product_id])
    option = Option.find(params[:option_id])
    @line_item = @cart.add_product(product, option)
    
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to :back }
        format.js
      else
        redirect_to product_url(product), notice: 'Sorry, there was a problem with the cart.'
      end
    end
  end
  
  def update
    if @line_item.update(line_item_params)
      redirect_to @line_item, notice: 'Line item was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @cart = set_cart
    @line_item = @cart.line_items.find(params[:id])
    @line_item.destroy
    redirect_to @cart
  end

  private
  
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:cart_id).permit(:line_item, :product_id, :option_id, :quantity, :extended_price, :extended_weight)
    end
    
end