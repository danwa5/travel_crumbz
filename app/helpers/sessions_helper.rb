module SessionsHelper

  def sign_in(user)
    remember_token = User.new_secure_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user?(user)
    user == current_user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.where(remember_token: remember_token).first
  end

  def current_user=(user)
    @current_user = user
  end

  def signed_in_user
    unless signed_in?
      store_location
      flash[:danger] = 'Please sign in.'
      redirect_to signin_url
    end
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def current_controller?(names)
    names.include?(controller_name)
  end
  
end
