class Api::V1::PostsController < Api::V1::BaseController

  def all
    @posts = Post.by_hot_score.paginate(page: params[:page])
    render json: @posts, each_serializer: PostSerializer
  end

  def show
    @post = Post.find(params[:id])
  end
end
