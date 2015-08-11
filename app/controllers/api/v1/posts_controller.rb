class Api::V1::PostsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!, only: [:create, :my, :upvote, :downvote]
  before_action :authenticate_user!, only: [:create, :my, :upvote, :downvote]
  before_action :set_post, only: [:show, :upvote, :downvote]

  def all
    to_show_premium = current_resource_owner ? current_resource_owner.is_premium : false
    @posts = Post.by_hot_score.show_premium(to_show_premium).paginate(page: params[:page])
    render json: @posts, each_serializer: PostSerializer
  end

  def my
    @posts = Post.my_phez(current_resource_owner, params[:page], current_resource_owner.is_premium)
    render json: @posts, each_serializer: PostSerializer
  end

  def show
    api_disallow_non_premium(@post.subphez)
  end

  def create
    @post = Post.new
    @subphez = Subphez.by_path(params[:subphez_path])
    if @subphez.nil?
      json = { 'success' => false, 'errors' => "could not find subphez with path: #{params[:subphez_path]}" }
      render(json: json) and return
    end
    if @subphez.is_admin_only and !current_resource_owner.is_admin
      json = { 'success' => false, 'errors' => 'admin-only subphez - authenticated user is not allowed to post here' }
      render(json: json) and return
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
      json = { 'success' => false, 'errors' => errors_text }
      render json: json
    end
  end

  def upvote
    if Vote.upvote(current_resource_owner, @post)
      json = { 'success' => true, 'post_id' => @post.id }
      render json: json
    else
      json = { 'success' => false, 'post_id' => @post.id, 'error' => 'There was a problem saving your vote.' }
      render json: json, status: :bad_request
    end
  end

  def downvote
    if Vote.downvote(current_resource_owner, @post)
      json = { 'success' => true, 'post_id' => @post.id }
      render json: json
    else
      json = { 'success' => false, 'post_id' => @post.id, 'error' => 'There was a problem saving your vote.' }
      render json: json, status: :bad_request
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
