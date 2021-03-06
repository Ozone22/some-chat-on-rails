module SessionsHelper

  def sign_in(user)
    remember_token = User.new_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    current_user == user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def sign_out
    current_user.update_attribute(:remember_token, User.encrypt(User.new_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def signed_in_user
    unless signed_in?
      flash[:warning] = 'Please sign in first'
      store_location
      redirect_to signin_url
    end
  end

  def correct_user
    user = User.find_by(id: params[:id])
    unless current_user?(user)
      flash[:warning] = 'Access denied'
      redirect_to current_user
    end
  end

  def redirect_current_user
    redirect_to current_user if signed_in?
  end

  # Set online, with expiration time - 10 minutes
  def set_online
    if current_user.present?
      REDIS.set(current_user.id, nil, ex: 10 * 60 )
    end
  end

end
