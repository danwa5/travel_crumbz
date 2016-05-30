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

    it 'must have the correct page header' do
      expect(page).to have_selector('div.page-header h2', text: 'My Trips')
    end

    it 'must have the featured photo grid' do
      expect(page).to have_selector('div#ri-grid')
    end

    it 'must have the featured photo grid' do
      expect(page).to have_selector('div#ri-grid')
    end

    it 'must have a link to add a trip within the photo grid' do
      expect(page).to have_selector('a.view-all span', text: 'ADD A TRIP')
      expect(page).to have_link('ADD A TRIP', href: new_user_trip_path(user))
    end
  end
end
