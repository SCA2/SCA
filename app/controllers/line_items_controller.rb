class LineItemsController < ApplicationController
  
  include CurrentCart
  
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  
  # GET /line_items
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  def create
    product = Product.find(params[:product_id])
    option = Option.find(params[:option_id])
    @line_item = @cart.add_product(product.id, option.id)

    if @line_item.save
      redirect_to @cart, notice: product.model + ' added to cart.'
    else
      redirect_to product_url(product), notice: 'Sorry, there was a problem with the cart.'
    end
  end
  
  # PATCH/PUT /line_items/1
#  def update
#    if @line_item.update(line_item_params)
#      redirect_to @line_item, notice: 'Line item was successfully updated.'
#    else
#      render action: 'edit'
#    end
#  end

  # DELETE /line_items/1
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
      params.require(:line_item).permit(:product_id)
    end

end