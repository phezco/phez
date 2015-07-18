class Api::V1::PostsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!, :only => [:create]
  before_action :authenticate_user!, :only => [:create]

  def all
    @posts = Post.by_hot_score.paginate(:page => params[:page])
    render json: @posts, each_serializer: PostSerializer
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    # not implemented yet
  end

end