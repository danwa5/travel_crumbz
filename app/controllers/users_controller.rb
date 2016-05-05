class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update]

  def show
    @trips = @user.trips
    @photos = current_trip.try(:photos)

    if current_trip && current_trip.locations.any?
      @location_hash = GoogleMaps::MappingService.call(current_trip.locations)
    end
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
    @user = User.find_by(username: params[:id])
    if !current_user?(@user)
      if signed_in?
        redirect_to(user_path(current_user))
      else
        redirect_to(signin_path)
      end
    end
  end

  def current_trip
    @current_trip = (current_user.trips.find_by(_slugs: params[:trip]) if params[:trip].present?) || @trips.most_recent.first
  end
end
