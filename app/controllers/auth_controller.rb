class AuthController < ApplicationController

  def create
    login(User.find_or_create_from_oauth(request.env['omniauth.auth'], current_user))
    redirect_to root_url
  end

  def destroy
    logout
    redirect_to root_url
  end
end