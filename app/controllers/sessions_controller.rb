class SessionsController < ApplicationController

  def new
    render 'new'
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user_path(user)
    else
      flash[:danger] = 'Invalid email/password combination'
      redirect_to signin_path
    end
  end
  
  def destroy
    sign_out
    redirect_to signup_path
  end

end
