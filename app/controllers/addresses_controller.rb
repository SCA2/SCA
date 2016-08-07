class AddressesController < BaseController

  before_action :set_addressable, except: :subregion_options
  before_action :set_address, only: [:show, :update]
  
  def subregion_options
    render partial: 'subregion_select'
  end
  
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
      flash[:notice] = "Address updated!"
      redirect_to [@addressable, @address]
    else
      render 'new', notice: 'Sorry, address could not be saved'
    end
  end
  
  private

    def set_addressable
      resource, id = request.path.split('/')[1, 2]
      @addressable = resource.singularize.classify.constantize.find(id)
    end
    
    def set_address
      @address = Address.find(params[:id])
    end
    
    def address_params
      params.require(:address).permit(:order_id, :user_id, :address_type, :first_name, :last_name, :address_1, :address_2, :city, :state_code, :post_code, :country, :telephone)
    end
end
