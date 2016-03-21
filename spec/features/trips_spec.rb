require 'rails_helper'

RSpec.describe 'Trips', type: :feature do
  let(:user) { create(:user, :with_trip) }
  before { sign_in(user) }

  describe 'GET /account/:user_id/trips/new' do
    before { visit new_user_trip_path(user) }
    it 'can create new a trip' do
      fill_in 'Name', with: 'Round the World'
      expect { click_button 'Add new trip' }.to change(Trip, :count).by(1)
    end
  end

  describe 'GET /account/:user_id/trips/:id/edit' do
    let(:trip) { create(:trip, :with_location, user_ids: [user.id], name: 'Trip 1')}
    before do
      visit edit_user_trip_path(user, trip)
      fill_in 'Name', with: 'Trip 2'
      fill_in 'Location', with: 'Mendoza, Argentina'
    end
    it 'can edit trip and location data' do
      click_button 'Update Trip'
      trip.reload
      expect(trip.name).to eq('Trip 2')
      expect(current_path).to eq(user_path(user))
      # is_expected.to have_selector('div.alert.alert-success', text: 'Trip updated')
    end
    it 'must have cancel button that redirects to user show page' do
      click_on 'Cancel'
      expect(current_path).to eq(user_path(user))
    end
  end

  describe 'DELETE /account/:user_id/trips/:id' do
    it 'must delete trip' do
      expect { click_link 'Delete trip' }.to change(Trip, :count).by(-1)
      expect(user.trips.count).to eq(0)
    end
    xit 'redirects to user show page with flash message' do
      click_link 'Delete Trip'
      expect(current_path).to eq(user_path(user))
      # is_expected.to have_selector('div.alert.alert-success', text: 'Trip deleted')
    end
  end
end
