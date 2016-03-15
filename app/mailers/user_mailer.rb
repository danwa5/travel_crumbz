class UserMailer < ActionMailer::Base
  default :from => 'support@travelcrumbz.com'

  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.full_name} <#{user.email}>", :subject => 'Travel Crumbz Registration Confirmation')
  end
end
