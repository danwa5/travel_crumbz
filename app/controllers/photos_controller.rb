class PhotosController < ApplicationController

  def create
    @photo = trip.photos.build(photo_params)
    if @photo.save
      flash[:success] = 'Photo successfully added!'
    else
      flash[:danger] = 'Photo upload failed!'
    end
    redirect_to current_user
  end

  private

  def photo_params
    params.require(:photo).permit!
  end

  def user
    @user ||= User.find_by(username: params[:user_id])
  end

  def trip
    @trip ||= user.trips.find(params[:trip_id])
  end
end
