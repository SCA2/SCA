class UsersController < ApplicationController
  
  include CurrentCart, SidebarData
  before_action :set_cart, :set_products

  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    if signed_in?
      redirect_to root_path, :notice => 'Already signed up!'
    else
      @user = User.new
    end
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    if signed_in?
      redirect_to root_path, :notice => 'Already signed up!'
    else
      @user = User.new(user_params)
      if @user.save
        sign_in @user
        redirect_to @user, :notice => "Signed up!"
      else
        render 'new'
      end
    end
  end
  
  # PATCH /users/:id
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      redirect_to @user, :notice => "Profile updated!"
    else
      render 'edit'
    end
  end
  
  # DELETE /users/:id
  def destroy
    target = User.find(params[:id])
    if (current_user == target) && (current_user.admin?)
      redirect_to users_url, :notice => "Can't delete yourself!"
    else
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end