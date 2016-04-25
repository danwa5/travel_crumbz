require 'rails_helper'

RSpec.describe 'Photos', type: :feature do
  let(:user) { create(:user, :with_trip) }
  let(:trip) { user.trips.first }
  let(:image_file) { Rails.root.join('spec/fixtures/images/photo-864x1152.jpg') }

  before do
    sign_in(user)
    visit edit_user_trip_path(user, trip)
  end

  describe 'POST /account/:user_id/trips/:trip_id/photos' do
    it 'can upload a new photo' do
      expect(trip.photos.count).to eq(0)
      click_button 'Upload Photos'
      page.attach_file('photo_original_file', image_file)
      click_button 'Upload'
      trip.reload
      expect(trip.photos.count).to eq(1)
    end
  end
end
