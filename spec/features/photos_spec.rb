require 'rails_helper'

RSpec.describe 'Photos', type: :feature do
  let(:user) { create(:user, :with_trip) }
  let(:trip) { user.trips.first }
  let(:image_file) { Rails.root.join('spec/fixtures/images/photo-864x1152.jpg') }

  before do
    sign_in(user)
    visit user_trip_path(user, trip)
  end

  describe 'POST /account/:user_id/trips/:trip_id/photos' do
    before do
      expect(trip.photos.count).to eq(0)
      click_link 'Upload photo'
      page.attach_file('photo_original_file', image_file)
      click_button 'Upload'
      trip.reload
    end

    it 'uploads a new photo' do
      expect(trip.photos.count).to eq(1)
    end

    it 'saves the original photo with the correct path' do
      photo = trip.photos.first
      expect(photo.original_file.url).to end_with("photo/#{photo.id}/original_file.#{photo.original_file.file.extension}")
    end

    it 'saves the small version with the correct path' do
      photo = trip.photos.first
      expect(photo.original_file.small.url).to end_with("photo/#{photo.id}/small_original_file.#{photo.original_file.file.extension}")
    end

    it 'saves the medium version with the correct path' do
      photo = trip.photos.first
      expect(photo.original_file.medium.url).to end_with("photo/#{photo.id}/medium_original_file.#{photo.original_file.file.extension}")
    end
  end
end
