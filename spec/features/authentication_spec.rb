require 'rails_helper'

RSpec.describe 'Authentication', type: :feature do

  subject { page }

  describe 'Sign Up page' do
    before { visit signup_path }
    it { is_expected.to have_title('Sign Up') }
    it { is_expected.to have_content('Sign Up') }

    context 'when submitting incomplete form' do
      it 'redirects to sign up page with error messages' do
        within("#new_user") do
          click_button 'Create my account'
        end
        is_expected.to have_title('Sign Up')
        is_expected.to have_content('Sign Up')
        is_expected.to have_selector('div.alert.alert-danger', text: 'The form contains')
      end
      it 'does not increase User count' do
        expect { click_button 'Create my account' }.not_to change(User, :count)
      end
    end
    context 'when submitting a complete form' do
      it 'navigates to user page' do
        within("#new_user") do
          fill_in 'Username', with: 'coconut'
          fill_in 'First name', with: 'Coconut'
          fill_in 'Last name', with: 'Jones'
          fill_in 'Email', with: 'coconut@jones.com'
          fill_in 'Password', with: '111111'
          fill_in 'Confirmation', with: '111111'
          click_button 'Create my account'
        end
        user = User.last
      end
      it 'increases User count by 1' do
        expect { click_button 'Create my account' }.to change(User, :count).by(1)
      end
    end
  end
end
 