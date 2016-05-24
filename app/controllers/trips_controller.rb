class TripsController < ApplicationController
  before_action :find_trip, only: [:show, :edit, :update, :destroy, :like]

  def show
    @photos = @trip.try(:photos)

    if @trip && @trip.locations.any?
      @location_hash = GoogleMaps::MappingService.call(@trip.locations)
    end
  end

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
      redirect_to user_trip_path(user, @trip)
    else
      render 'edit'
    end
  end

  def destroy
    @trip.destroy
    flash[:success] = 'Trip deleted!'
    redirect_to @user
  end

  def like
    @trip.likes += 1
    @trip.save
    redirect_to user_trip_path(user, @trip)
  end

  private

  def trip_params
    params.require(:trip).permit(:name, locations_attributes: [:id, :address, :order, :created_at, :updated_at])
  end

  def user
    @user ||= User.where(username: params[:user_id]).first
  end

  def find_trip
    if current_user?(user)
      @trip = user.trips.find(params[:id])
    else
      redirect_to(user_path(current_user))
    end
  end
end
