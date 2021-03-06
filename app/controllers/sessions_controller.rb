class SessionsController < ApplicationController

  def new
    render 'new'
  end
  
  def create
    user = User.where(email: params[:session][:email].downcase).first
    if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
        sign_in user
        redirect_back_or user_path(user)
      else
        flash[:danger] = 'Please activate your account by following the instructions in the account confirmation email you received to proceed.'
        redirect_to signin_path
      end
    else
      flash[:danger] = 'Invalid email/password combination'
      redirect_to signin_path
    end
  end
  
  def destroy
    sign_out
    redirect_to signin_path
  end

end
