class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      flash[:success] = 'Please confirm your email address to continue.'
      redirect_to signin_path
    else
      render 'new'
    end
  end

  def confirm_email
    user = User.find_by(confirm_token: params[:id])
    if user
      user.email_activate
      sign_in user
      flash[:success] = 'Welcome to the Travel Crumbz! Your account has been confirmed.'
      redirect_to user_path(user)
    else
      flash[:danger] = 'Sorry. User does not exist.'
      redirect_to signin_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :username, :email,
                                 :password, :password_confirmation)
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(signup_path) unless current_user?(@user)
  end
end