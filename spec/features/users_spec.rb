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

    it 'must have a link to add a trip within the photo grid' do
      expect(page).to have_selector('a.view-all span', text: 'ADD A TRIP')
      expect(page).to have_link('ADD A TRIP', href: new_user_trip_path(user))
    end
  end

  describe 'GET /account/:id/edit' do
    before do
      visit(edit_user_path(user))
      expect(status_code).to eq(200)
    end

    it 'must have the correct page header' do
      expect(page).to have_selector('div.page-header h2', text: 'Update Account Settings')
    end

    it 'must be redirected to user show page after clicking on Cancel button' do
      click_link 'Cancel'
      expect(current_path).to eq(user_path(user))
    end

    context 'invalid submission' do
      it 'must display error flash message' do
        click_button 'Save changes'
        expect(current_path).to eq(user_path(user))
        is_expected.to have_selector('div.alert.alert-danger', text: /The form contains the.*error/)
      end
    end

    context 'valid form submission' do
      it 'must update user attributes' do
        fill_in 'First name', with: 'Coconut'
        fill_in 'Password', with: '123456'
        fill_in 'Confirmation', with: '123456'
        click_button 'Save changes'
        user.reload
        expect(current_path).to eq(user_path(user))
        expect(user.first_name).to eq('Coconut')
        is_expected.to have_selector('div.alert.alert-success', text: 'Account settings updated!')
      end
    end
  end
end
