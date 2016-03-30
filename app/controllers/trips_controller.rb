class TripsController < ApplicationController
  before_action :find_trip, only: [:edit, :update, :destroy]

  def new
    @trip = user.trips.build
  end

  def create
    @trip = user.trips.new(trip_params)
    if @trip.save
      flash[:success] = 'Trip successfully added!'
      redirect_to user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @trip.update_attributes(trip_params)
      flash[:success] = 'Trip updated!'
      redirect_to user_path(user, trip: @trip.slug)
    else
      render 'edit'
    end
  end

  def destroy
    @trip.destroy
    flash[:success] = 'Trip deleted!'
    redirect_to @user
  end

  private

  def trip_params
    params.require(:trip).permit(:name, locations_attributes: [:id, :address, :order, :created_at, :updated_at])
  end

  def user
    @user ||= User.find_by(username: params[:user_id])
  end

  def find_trip
    if current_user?(user)
      @trip = user.trips.find(params[:id])
    else
      redirect_to(user_path(current_user))
    end
  end
end
