class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :throttle, only: [:create]

  def suggest_title
    suggested_title = Post.suggest_title(params[:url])
    respond_to do |format|
      if suggested_title.blank?
        json = { 'suggest' => false }
      else
        json = { 'suggest' => true, 'title' => suggested_title }
      end
      format.json { render json: json, status: :ok }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.where(id: params[:post_id]).first
    if @post.nil?
      redirect_to root_path, alert: 'Could not find post.' and return
    end
    disallow_non_premium(@post.subphez)
    @comments = @post.root_comments
    @comment = Comment.new
    @show_context = true
  end

  # GET /posts/new
  def new
    @subphez = nil
    @subphez = Subphez.by_path(params[:path]) if params[:path]
    if @subphez && @subphez.is_admin_only && !current_user.is_admin
      redirect_to root_path,
                  alert: 'Only Admins are allowed to post here.' and return
    end
    @post = Post.new
    @post.url = params[:url] if params[:url]
    @post.title = params[:title] if params[:title]
  end

  # GET /posts/1/edit
  def edit
    redirect_to :back unless @post.owner?(current_user)
    @subphez = @post.subphez
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @subphez = Subphez.by_path(params[:subphez_path]) if params[:subphez_path]
    if @subphez.nil?
      render action: :new,
      alert: "Could not find Subphez with path: #{params[:subphez_path]}" and return
    end
    @post.subphez = @subphez
    if @subphez.is_admin_only && !current_user.is_admin
      redirect_to root_path,
                  alert: 'Only Admins are allowed to post here.' and return
    end
    @post.user_id = current_user.id
    @post.vote_total = 1
    @post.is_premium_only = @subphez.is_premium_only
    if @post.url.strip.blank?
      @post.is_self = true
    else
      @post.body = nil
    end
    if @post.save
      redirect_to build_post_path(@post),
                  notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    redirect_to :back unless @post.owner?(current_user)
    if @post.update(post_params)
      redirect_to build_post_path(@post),
                  notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    if @post.owner?(current_user) || @post.moderateable?(current_user)
      @post.destroy
    end
    redirect_to root_path,
                notice: 'Post was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def post_params
    params.require(:post).permit(:subphez_id, :url, :title, :is_self, :body)
  end
end
