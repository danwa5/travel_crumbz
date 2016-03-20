class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update]

  def show
    @trips = @user.trips

    # Display locations from last trip in map
    @current_trip = @trips.all.desc('created_at').first

    if @current_trip && @current_trip.locations.any?
      @location_hash = Gmaps4rails.build_markers(@current_trip.locations) do |location, marker|
        marker.lat location.latitude
        marker.lng location.longitude
        marker.title location.address
        marker.infowindow location.address
      end
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
    # redirect_to(signin_path) unless current_user?(@user)
  end
end
