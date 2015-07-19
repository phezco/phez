class Api::V1::PostsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!, :only => [:create, :my]
  before_action :authenticate_user!, :only => [:create, :my]

  def all
    @posts = Post.by_hot_score.paginate(:page => params[:page])
    render json: @posts, each_serializer: PostSerializer
  end

  def my
    @posts = Post.my_phez(current_resource_owner, params[:page], current_resource_owner.is_premium)
    render json: @posts, each_serializer: PostSerializer
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new
    @subphez = Subphez.by_path(params[:subphez_path])
    if @subphez.nil?
      json = {'success' => false, 'errors' => "could not find subphez with path: #{params[:subphez_path]}"}
      render json: json and return
    end
    if @subphez.is_admin_only && !current_resource_owner.is_admin
      json = {'success' => false, 'errors' => "admin-only subphez - authenticated user is not allowed to post here"}
      render json: json and return
    end
    @post.subphez = @subphez
    @post.url = params[:url]
    @post.title = params[:title]
    @post.body = params[:body]
    @post.user_id = current_resource_owner.id
    @post.vote_total = 1
    @post.is_premium_only = @subphez.is_premium_only
    if @post.url.blank?
      @post.is_self = true
    else
      @post.body = nil
    end
    if @post.save
      render json: @post, serializer: PostSerializer
    else
      errors_text = @post.errors.full_messages.join('; ')
      json = {'success' => false, 'errors' => errors_text}
      render json: json
    end
  end

end