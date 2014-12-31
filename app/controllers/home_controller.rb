class HomeController < ApplicationController

  def router
    if current_user.present?
      redirect_to edit_user_url(current_user)
    else
      render 'static/homepage'
    end
  end
end