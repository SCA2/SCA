class PasswordResetsController < BaseController

  before_action :get_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
    @reset = PasswordResetValidator.new
  end
  
  def create
    @reset = PasswordResetValidator.new(params)
    render 'new' and return unless @reset.valid?
    @user = User.find_by_email(@reset.email)
    if @user
      logger.debug "Mailer: " + @user.inspect
      @user.send_password_reset
    end
    redirect_to root_url, notice: 'Password reset instructions sent!'
  end
  
  def edit
    unless @user.password_reset_token == params[:id]
      flash.now[:alert] = "Sorry, that's not a valid reset token."
      render 'new'
    end
  end
  
  def update
    if @user.update(password_params)
      redirect_to root_url, notice: 'Password reset!'
    else
      flash.now[:notice] = "Sorry, we couldn't update your password."
      render :edit
    end
  rescue
    redirect_to root_url
  end
  
  private
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by_email(params[:email])
      redirect_to home_path unless @user
    end

    def check_expiration
      if @user.password_reset_sent_at < 2.hours.ago
        flash[:alert] = "Password reset link has expired!"
        redirect_to new_password_reset_path
      end
    end
end
