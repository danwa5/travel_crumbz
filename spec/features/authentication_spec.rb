require 'rails_helper'

RSpec.describe 'Authentication', type: :feature do

  subject { page }

  describe 'Sign Up process' do
    let(:submit) { 'Create my account' }

    before { visit signup_path }
    it { is_expected.to have_title('Sign Up') }
    it { is_expected.to have_content('Sign Up') }

    context 'when submitting an incomplete form' do
      it 'redirects to sign up page with error messages' do
        within("#new_user") do
          click_button submit
        end
        is_expected.to have_title('Sign Up')
        is_expected.to have_content('Sign Up')
        is_expected.to have_selector('div.alert.alert-danger', text: 'The form contains')
      end
      it 'does not increase User count' do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    context 'when submitting a complete form' do
      before do
        within("#new_user") do
          fill_in 'Username', with: 'coconut'
          fill_in 'First name', with: 'Coconut'
          fill_in 'Last name', with: 'Jones'
          fill_in 'Email', with: 'coconut@jones.com'
          fill_in 'Password', with: '111111'
          fill_in 'Confirmation', with: '111111'
        end
      end
      it 'increases User count by 1' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'after creating user' do
        before { click_button submit }
        let(:user) { User.last }

        it 'user account needs to be activated' do
          expect(user.confirm_token).to be_present
          is_expected.to have_selector('div.alert.alert-success', text: 'Please confirm your email address to continue')
        end

        context 'after clicking on activation link in email with valid confirmation token' do
          before { visit confirm_email_user_path(user.confirm_token) }
          it 'should redirect to user show page' do
            expect(current_path).to eq(user_path(user))
          end
          it { is_expected.to have_selector('div.alert.alert-success', text: 'Welcome') }
        end
        context 'guessing activation path with invalid confirmation token' do
          before { visit confirm_email_user_path('abc123') }
          it 'should redirect user to sign-in page' do
            expect(current_path).to eq(signin_path)
          end
          it { is_expected.to have_selector('div.alert.alert-danger', text: 'Sorry') }
        end
      end
    end
  end

  describe 'Sign In process' do
    let(:submit) { 'Sign In' }

    before { visit signin_path }
    it { is_expected.to have_content('Sign In') }
    it { is_expected.to have_title('Sign In') }

    describe 'when trying to access an account without signing in' do
      let(:stranger) { create(:user, username: 'stranger') }
      it 'navigates back to sign-in page' do
        visit user_path(stranger)
        expect(current_path).to eq(signin_path)
      end
    end

    context 'when submitting with invalid credentials' do
      before do
        within('#sign-in-panel') do
          click_button submit
        end
      end
      it 'redirects user to sign-in page with warning message' do
        expect(current_path).to eq(signin_path)
        is_expected.to have_selector('div.alert.alert-danger', text: 'Invalid email/password combination')
      end
    end

    context 'when submitting with valid credentials' do
      before do
        within('#sign-in-panel') do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: '111111'
          click_button submit
        end
      end
      context 'but without activating account thru email confirmation' do
        let(:user) { create(:user, password: '111111', email_confirmed: false) }
        it 'redirects user to sign-in page with warning message' do
          expect(current_path).to eq(signin_path)
          is_expected.to have_selector('div.alert.alert-danger', text: 'Please activate your account')
        end
      end
      context 'after activating account' do
        let(:user) { create(:user, password: '111111') }
        it 'navigates to user show page' do
          expect(current_path).to eq(user_path(user))
          expect(Capybara.current_session.driver.request.cookies.[]('remember_token')).to be_present
        end

        describe 'trying to access someone else\'s account' do
          let(:user2) { create(:user, username: 'user2') }
          it 'navigates back to user show page' do
            visit user_path(user2)
            expect(current_path).to eq(user_path(user))
          end
        end

        describe 'Sign Out process' do
          it 'redirects user to sign-in page and deletes the remember_token cookie' do
            visit signout_path
            expect(current_path).to eq(signin_path)
            expect(Capybara.current_session.driver.request.cookies.[]('remember_token')).to be_nil
          end
        end
      end
    end
  end
end
 