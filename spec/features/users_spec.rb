require 'rails_helper'

RSpec.describe 'Users', type: :feature do
  let(:user) { create(:user) }
  before { sign_in(user) }

  subject { page }

  describe 'GET /account/:id' do
    before { visit(user_path(user)) }

    context 'when user has no trips' do
      it 'the user show page should render correctly' do
        expect(current_path).to eq("/account/#{user.username}")
        expect(status_code).to eq(200)
        expect(user.trips.count).to eq(0)
      end

      describe 'display a navigation bar' do
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
      # Hack - create trip and associate with existing user (not working)
      # let(:trip) { create(:trip, :with_location, users: [user], name: 'First Trip') }
      let(:user) { create(:user, :with_trip) }
      let(:trip) { user.trips.first }

      before do
        expect(user.trips.count).to eq(1)
      end

      it 'the user show page should render correctly', js: true do
        expect(current_path).to eq("/account/#{user.username}")
        user.reload
        expect(status_code).to eq(200)
        expect(user.trips.count).to eq(1)
      end

      describe 'display a navigation bar' do
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
  end
end
