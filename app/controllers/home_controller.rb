class HomeController < ApplicationController
  before_action :authenticate_user!, :only => [:my]

  def index
    @posts = Post.by_hot_score.paginate(:page => params[:page])
  end

  def my
    @posts = Post.my_phez(current_user, params[:page])
  end

  def privacy
  end

end