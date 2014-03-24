class AddressesController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :set_billing_address, only: [:show, :edit, :update, :destroy]
  before_action :set_shipping_address, only: [:show, :edit, :update, :destroy]
  
  def show_billing
    set_billing_address
    if @shipping_address == nil
      @shipping_address = @billing_address.dup
    end  
  end
  
  def show_shipping
    set_shipping_address    
    if @billing_address == nil
      @billing_address = @shipping_address.dup
    end  
  end

  def new
    @billing_address = Address.new
    @shipping_address = Address.new
  end
  
  def create_billing
    @billing_address = Address.new(address_params)
    if @billing_address.save
      redirect_to address_url(@billing_address), notice: 'Billing address saved'
    else
      render 'new', notice: 'Sorry, address could not be saved'
    end
  end
  
  def create_shipping
    @shipping_address = Address.new(address_params)
    if @shipping_address.save
      render 'show', notice: 'Shipping address saved'
    else
      render 'new', notice: 'Sorry, address could not be saved'
    end
  end
  
  def update_billing
    set_billing_address
    if @billing_address.update(address_params)
      redirect_to address_url(@billing_address), notice: 'Billing address updated'
    else
      render 'new', notice: 'Sorry, address could not be saved'
    end
  end
  
  def update_shipping
    set_shipping_address
    if @shipping_address.update(address_params)
      render 'show', notice: 'Shipping address updated'
    else
      render 'new', notice: 'Sorry, address could not be saved'
    end
  end
  
  def copy_billing
    if @billing_address
      @shipping_address.first_name = @billing_address.first_name
      @shipping_address.last_name = @billing_address.last_name
      @shipping_address.address_1 = @billing_address.address_1
      @shipping_address.address_2 = @billing_address.address_2
      @shipping_address.city = @billing_address.city
      @shipping_address.state = @billing_address.state
      @shipping_address.post_code = @billing_address.post_code
      @shipping_address.country = @billing_address.country
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_billing_address
      @billing_address = Address.find(params[:id])
    end

    def set_shipping_address
      @shipping_address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:cart_id, :first_name, :last_name, :address_1, :address_2, :city, :state, :post_code, :country, :telephone)
    end
end
