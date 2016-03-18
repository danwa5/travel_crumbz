def sign_in(user, options={})
  visit signin_path
  fill_in('Email', with: user.email, match: :first)
  fill_in('Password', with: user.password, match: :first)
  click_button 'Sign In', match: :first
end
