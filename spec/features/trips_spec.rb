require 'rails_helper'

RSpec.describe 'Trips', type: :feature do
  let(:user) { create(:user, :with_trip) }
  before { sign_in(user) }

  subject { page }

  describe 'GET /account/:user_id/trips/:id' do
    let(:trip) { user.trips.first }

    before do
      visit user_trip_path(user, trip)
      expect(user.trips.count).to eq(1)
    end

    describe 'display a navigation bar' do
      it 'must show a "My Trips" button with a link to trip' do
        is_expected.to have_selector('button', text: 'My Trips')
        expect(find('ul.dropdown-menu').find('li')).to have_content(/Trip #/)
      end
      it 'must have an "New trip" button' do
        is_expected.to have_link('New trip', href: new_user_trip_path(user))
      end
      it 'must have an "Edit trip" button' do
        is_expected.to have_link('Edit trip', edit_user_trip_path(user, trip))
      end
      it 'must have an "Upload Photos" button' do
        is_expected.to have_link('Upload photo')
        is_expected.to have_css("a[data-toggle='modal'][data-target='#myModal']")
      end
      it 'must have a "Delete trip" button' do
        is_expected.to have_link('Delete trip')
      end
    end
  end

  describe 'GET /account/:user_id/trips/new' do
    before { visit new_user_trip_path(user) }
    it 'can create new a trip' do
      fill_in 'Name', with: 'Round the World'
      expect { click_button 'Add new trip' }.to change(Trip, :count).by(1)
    end
    xit 'can create new a trip with location', js: true do
      fill_in 'Name', with: 'Round the World'
      click_button 'Add Location'
      fill_in 'Location', with: 'Sydney, Australia'
      click_button 'Add new trip'
      expect(user.trips.count).to eq(1)
    end
  end

  describe 'GET /account/:user_id/trips/:id/edit' do
    let(:trip) { create(:trip, :with_location, user_ids: [user.id], name: 'Trip 1')}
    before do
      make_google_maps_stub_request
      visit edit_user_trip_path(user, trip)
      fill_in 'Name', with: 'Trip 2'
      fill_in 'Location', with: 'Mendoza, Argentina'
    end
    it 'can edit trip and location data' do
      click_button 'Update Trip'
      trip.reload
      expect(trip.name).to eq('Trip 2')
      expect(current_path).to eq(user_trip_path(user, trip))
      # is_expected.to have_selector('div.alert.alert-success', text: 'Trip updated')
    end
    it 'must have cancel button that redirects to user show page' do
      click_on 'Cancel'
      expect(current_path).to eq(user_trip_path(user, trip))
    end
  end

  describe 'DELETE /account/:user_id/trips/:id' do
    before { visit user_trip_path(user, user.trips.first) }
    it 'must delete trip' do
      expect { click_link 'Delete trip' }.to change(Trip, :count).by(-1)
      expect(user.trips.count).to eq(0)
    end
    xit 'redirects to user show page with flash message' do
      click_link 'Delete trip'
      expect(current_path).to eq(user_path(user))
      is_expected.to have_selector('div.alert.alert-success', text: 'Trip deleted')
    end
  end

  def make_google_maps_stub_request
    stub_request(:get, /maps.googleapis.com\/maps\/api\/geocode\/.+/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end
end
