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
    end
    context 'when user has a trip' do
      before do
        create(:trip, :with_location, user_ids: [user.id], name: 'First Trip')
      end
      it 'the user show page should render correctly', js: true do
        user.reload
        expect(current_path).to eq("/account/#{user.username}")
        expect(status_code).to eq(200)
        expect(user.trips.count).to eq(1)
        # trips = page.all('table#user-trips tr.active td').map(&:text)
        # expect(find('table#user-trips').find('tr.active td.trip-name')).to have_content('First Trip')
        # is_expected.to have_selector('td', text: /First Trip/i)
        # is_expected.to have_content('First Trip')
      end
    end
  end
end
