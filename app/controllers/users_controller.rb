class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    # not currently used
  end

  def subscriptions
    @subphezes = current_user.subscribed_subphezes
  end

end