class TripsController < ApplicationController

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
    @trip = user.trips.find(params[:id])
    @locations = @trip.locations
  end

  def update
    @trip = user.trips.find(params[:id])
    if @trip.update_attributes(trip_params)
      flash[:success] = 'Trip updated!'
      redirect_to user_path(user)
    else
      render 'edit'
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:name, locations_attributes: [:id, :address, :created_at, :updated_at])
  end

  def user
    @user ||= User.find_by(username: params[:user_id])
  end
end
