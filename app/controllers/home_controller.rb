class HomeController < ApplicationController

  def index
    @posts = Post.by_hot_score.paginate(:page => params[:page])
  end

end