class PhotosController < ApplicationController

  def create
    @photo = trip.photos.build(photo_params)
    if @photo.save
      flash[:success] = 'Photo successfully added!'
    else
      flash[:danger] = 'Photo upload failed! Kindly note a trip cannot contain duplicate photos.'
    end
    redirect_to current_user
  end

  private

  def photo_params
    params.require(:photo).permit!
  end

  def user
    @user ||= User.where(username: params[:user_id]).first
  end

  def trip
    @trip ||= user.trips.find(params[:trip_id])
  end
end
