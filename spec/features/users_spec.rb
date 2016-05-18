require 'rails_helper'

RSpec.describe 'Users', type: :feature do
  let(:user) { create(:user) }
  before { sign_in(user) }

  subject { page }

  describe 'GET /account/:id' do
    before do
      visit(user_path(user))
      expect(current_path).to eq("/account/#{user.username}")
      expect(status_code).to eq(200)
    end

    context 'when user has no trips' do
      before { expect(user.trips.count).to eq(0) }

      it { is_expected.to have_content('You have not added any trips.') }

      xdescribe 'display a navigation bar' do
        it 'must show a "My Trips" button with a disabled dropdown item' do
          is_expected.to have_selector('button', text: 'My Trips')
          expect(find('ul.dropdown-menu').find('li.disabled')).to have_content('You have 0 trips')
        end
        it 'must show a "Add new trip" button' do
          is_expected.to have_link('Add new trip', href: new_user_trip_path(user))
        end
        it 'must not have an "Edit trip" button' do
          is_expected.not_to have_link('Edit trip')
        end
        it 'must not have a "Delete trip" button' do
          is_expected.not_to have_link('Delete trip')
        end
      end
    end

    context 'when user has a trip' do
      # Workaround - create trip and associate with existing user (not working)
      # let(:trip) { create(:trip, :with_location, users: [user], name: 'First Trip') }
      let(:user) { create(:user, :with_trip) }
      let(:trip) { user.trips.first }

      before { expect(user.trips.count).to eq(1) }

      xdescribe 'display a navigation bar' do
        it 'must show a "My Trips" button with a link to trip' do
          is_expected.to have_selector('button', text: 'My Trips')
          expect(find('ul.dropdown-menu').find('li')).to have_content(/Trip #/)
        end
        it 'must have a "Add new trip" button' do
          is_expected.to have_link('Add new trip', href: new_user_trip_path(user))
        end
        it 'must have an "Edit trip" button' do
          is_expected.to have_link('Edit trip', edit_user_trip_path(user, trip))
        end
        it 'must have a "Delete trip" button' do
          is_expected.to have_link('Delete trip')
        end
      end
    end

    context 'when user has multiple trips' do
      let!(:user) { create(:user, :with_3_trips) }

      before { expect(user.trips.count).to eq(3) }

      xdescribe 'display a navigation bar' do
        it 'must show a "My Trips" button with a link to trip' do
          is_expected.to have_selector('button', text: 'My Trips')
          expect(find('ul.dropdown-menu').find('li.active')).to have_content(/Trip #/)
        end
        it 'must have a "Add new trip" button' do
          is_expected.to have_link('Add new trip', href: new_user_trip_path(user))
        end
        it 'must have an "Edit trip" button' do
          trip = user.trips.most_recent.first
          is_expected.to have_link('Edit trip', edit_user_trip_path(user, trip))
        end
        it 'must have a "Delete trip" button' do
          is_expected.to have_link('Delete trip')
        end
      end

      xdescribe 'select a trip from the "My Trips" menu' do
        it 'displays the trip on the map' do
          last_trip = user.trips.most_recent.first
          expect(find('ul.dropdown-menu').find('li.active')).to have_content(last_trip.name)
          click_on 'My Trips'
          trip = user.trips.most_recent.skip(1).limit(1).first
          click_on trip.name
          expect(find('ul.dropdown-menu').find('li.active')).to have_content(trip.name)
        end
      end
    end
  end
end
