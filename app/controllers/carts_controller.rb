class CartsController < ApplicationController
  
  include CurrentCart
  
  before_action :set_products
  before_action :signed_in_admin, except: [:show]
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  
  # GET /carts
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  def show   
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  def create
    @cart = Cart.new(cart_params)
    
    if @cart.save
      redirect_to @cart, notice: 'Cart was successfully created.'
    else
      render action: 'new'
    end
  end
  
  
  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params[:cart]
    end

    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, notice: 'Invalid cart'
    end
    
    def set_products
      @products = Product.order(:category_weight, :model_weight)
    end 
end