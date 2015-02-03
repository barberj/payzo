class HomeController < ApplicationController
  before_filter :require_login, only: [:dashboard]

  def router
    if current_user.present?
      redirect_to edit_user_url(current_user)
    else
      render 'static/homepage'
    end
  end

  def dashboard
    render :layout => "sidebar"
  end
end
