class UsersController < ApplicationController

  include CurrentCart, SidebarData
  before_action :set_cart, :set_products

  before_action :signed_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :admin_user, only: [:index, :destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    if signed_in?
      redirect_to root_path, :notice => 'Already signed up!'
    else
      @user = User.new
      @user.addresses.build(address_type: 'billing')
      @user.addresses.build(address_type: 'shipping')
    end
  end

  def show
    @user = User.find(params[:id])
    @billing = @user.addresses.find_by(address_type: 'billing')
    @shipping = @user.addresses.find_by(address_type: 'shipping')
  end

  def create
    if signed_in?
      redirect_to home_path, :notice => 'Already signed up!'
    else
      @user = User.new(user_params)
      if @user.save
        sign_in @user
        UserMailer.signup_confirmation(@user).deliver
        redirect_to @user, :flash => { :success => "Signed up!" }
      else
        render 'new'
      end
    end
  end
  
  def edit
    @billing = @user.addresses.find_or_create_by(:address_type => 'billing')
    @shipping = @user.addresses.find_or_create_by(:address_type => 'shipping')
  end
  
  def update
    if @user.update(user_params)
      redirect_to @user, :notice => "Profile updated!"
    else
      render 'edit'
    end
  end
  
  def destroy
    target = User.find(params[:id])
    if (current_user == target) && (current_user.admin?)
      redirect_to users_path, :notice => "Can't delete yourself!"
    else
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_path
    end
  end
  
  private

    def user_params
      params.require(:user).permit( :name, :email, :password, :password_confirmation,
        :contact_news, :contact_updates, :contact_sales, 
        :addresses_attributes => [:id, :address_type,
          :first_name, :last_name, :address_1, :address_2,
          :city, :state_code, :post_code, :country, :telephone])
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(home_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(home_path) unless signed_in_admin?
    end

end

