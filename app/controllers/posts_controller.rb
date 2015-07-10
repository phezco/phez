class PostsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]
  before_action :set_post, only: [:edit, :update, :destroy]

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:post_id])
    @upvoted, @downvoted = false, false
    if current_user
      @vote = Vote.voted(current_user, @post)
      if @vote
        @upvoted = @vote.upvote?
        @downvoted = @vote.downvote?
      end
    end
  end

  # GET /posts/new
  def new
    @subphez = Subphez.by_path(params[:path])
    @post = Post.new
    @post.subphez_id = @subphez.id
  end

  # GET /posts/1/edit
  def edit
    redirect_to :back unless @post.owner?(current_user)
    @subphez = @post.subphez
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.vote_total = 1
    if @post.url.blank?
      @post.is_self = true
    else
      @post.body = nil
    end
    respond_to do |format|
      if @post.save
        format.html { redirect_to build_post_path(@post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to build_post_path(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy if @post.owner?(current_user)
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:subphez_id, :url, :title, :is_self, :body)
    end
end
