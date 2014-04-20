class AddressesController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :set_addressable
  before_action :set_address, only: [:show, :update]
  
  def index
    @addresses = @addressable.addresses
  end
  
  def new
    @type = params[:type]
    @address = @addressable.addresses.new
  end
  
  def show
    @type = @address.address_type
  end
  
  def update
    @address = @addressable.addresses.find(params[:address_id])   
    if @address.update(address_params)
      redirect_to [@addressable, @address], notice: 'Address updated'
    else
      render 'new', notice: 'Sorry, address could not be saved'
    end
  end
  
  private

    def set_addressable
      resource, id = request.path.split('/')[1, 2]
      @addressable = resource.singularize.classify.constantize.find(id)
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:order_id, :user_id, :address_type, :first_name, :last_name, :address_1, :address_2, :city, :state_code, :post_code, :country, :telephone)
    end
end
