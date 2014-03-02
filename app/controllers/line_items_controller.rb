class LineItemsController < ApplicationController
  
  include CurrentCart
  
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  
  def create
    
    product = Product.find(params[:product_id])
    @line_item = @cart.line_items.build(product: product)
    
    if @line_item.save
      redirect_to @line_item.cart, notice: 'Line item was successfully created.'
    else
      render action: 'new'
    end
  end
  
  private
  
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end
end