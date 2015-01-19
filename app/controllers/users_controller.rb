class UsersController < ApplicationController

  before_filter :require_login, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to :back, notice: 'User was successfully updated.'
    else
      redirect_to :back
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def initiate_new_demo
    login(User.create!(email: "#{SecureRandom.hex.first(12)}@payzodemo.com",
                       url_handle: "change-your-demo-payment-url-#{SecureRandom.hex.first(4)}",
                       company_name: "Demo Company Inc",
                       company_description: "Demo company description",
                       demo: true))
    redirect_to root_url
  end

private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:url_handle, :company_name, :company_description, :email, :avatar)
  end
end
