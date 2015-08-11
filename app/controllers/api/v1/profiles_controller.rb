class Api::V1::ProfilesController < Api::V1::BaseController
  before_filter :set_by_username

  def posts
    @posts = @user.posts.latest.paginate(page: params[:page])
    render json: @posts, each_serializer: PostSerializer
  end

  def comments
    @comments = @user.comments.latest.paginate(page: params[:page])
  end

  def show
  end

  private

  def set_by_username
    @user = User.where(username: params[:username]).first
    if @user.nil?
      render(json: errors_json("Could not find user: #{params[:username]}"), status: :not_found) and return
    end
  end
end
