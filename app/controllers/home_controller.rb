class HomeController < ApplicationController
  before_action :authenticate_user!, :only => [:my]

  def index
    to_show_premium = user_signed_in? ? current_user.is_premium : false
    @posts = Post.by_hot_score.show_premium(to_show_premium).paginate(:page => params[:page])
  end

  def my
    to_show_premium = user_signed_in? ? current_user.is_premium : false
    @posts = Post.my_phez(current_user, params[:page], to_show_premium)
  end

  def privacy
  end

  def thanks
  end

end