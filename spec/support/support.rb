def sign_in(user, options={})
  visit signin_path
  within('#sign-in-form') do
    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password)
    click_button 'Sign In'
  end
end
