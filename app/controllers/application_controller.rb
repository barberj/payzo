class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_filter :redirect_to_www
  before_filter :update_user_last_activity

  def login(user)
    session[:current_user_id] = user.id
  end

  def current_user
    user = User.find_by_id(session[:current_user_id])
    logout if user.nil?
    user
  end

  def logout
    session[:current_user_id] = nil
  end

  def require_login
    redirect_to root_url and return unless current_user.present?
  end

private

  def redirect_to_www
    if ENV['PING_URL'] == 'https://www.payzo.io'
      unless request.host == 'www.payzo.io'
       redirect_to 'https://www.payzo.io' + request.fullpath, status: 301
      end
    end
  end

  def update_user_last_activity
    current_user.update_attribute(:last_active_at, Time.now) if current_user.present?
  end
end
