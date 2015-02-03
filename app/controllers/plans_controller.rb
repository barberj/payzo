class PlansController < ApplicationController
  layout "sidebar"
  before_filter :require_login

  def index
    #@plans = current_user.plans.all
    @plans = [{},{},{},{},{}]
    #@plans = []
  end

  def new
    #
  end
end
