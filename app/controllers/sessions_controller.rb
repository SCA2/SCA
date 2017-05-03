 class SessionsController < BaseController
  
  def new
    @session = SessionValidator.new
  end

  def create
    @session = SessionValidator.new(session_params)
    render 'new' and return unless @session.valid?

    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to home_url
  end

  private

  def session_params
    params.require(:session_validator).permit(:email, :password, :password_confirmation, :remember_me)
  end
  
end
