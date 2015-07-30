class SubphezesController < ApplicationController
  before_action :authenticate_user!,
                except: [:index, :show, :latest, :autocomplete, :random]
  before_action :set_subphez, only: [:edit, :update, :destroy]
  before_action :set_subphez_by_path,
                only: [:show, :latest, :manage, :add_moderator,
                       :remove_moderator, :approve_modrequest,
                       :update_modrequest]

  before_action :frozen_check!,
                only: [:new, :create, :update, :manage, :approve_moderator,
                       :remove_moderator, :approve_modrequest, :update_modrequest]

  def autocomplete
    @subphezes = Subphez.where('path ILIKE ?', "#{params[:term]}%")
                        .order('path ASC')
    @paths = @subphezes.collect { |s| s.path }
    respond_to do |format|
      format.json { render json: @paths.to_json }
    end
  end

  # GET /subphezs
  # GET /subphezs.json
  def index
    @subphezes = Subphez.top_by_subscriber_count(100)
  end

  # GET /subphezs/1
  # GET /subphezs/1.json
  def show
    disallow_non_premium(@subphez)
    @posts = @subphez.posts.by_hot_score.paginate(page: params[:page])
    @vote_hash = Vote.vote_hash(current_user, @posts)
  end

  def latest
    disallow_non_premium(@subphez)
    @posts = @subphez.posts.latest.paginate(page: params[:page])
    @vote_hash = Vote.vote_hash(current_user, @posts)
  end

  def manage
    if !current_user.can_moderate?(@subphez)
      redirect_to build_subphez_path(@subphez),
                  alert: 'You are not a moderator of this subphez.' and return
    end
    @mod_request = ModRequest.new
  end

  def add_moderator
    if !current_user.can_moderate?(@subphez)
      redirect_to :back,
                  alert: 'You are not a moderator of this subphez.' and return
    end
    @user = User.by_username_insensitive(params[:username])
    if @user.nil?
      redirect_to :back,
                  alert: 'Could not find user with that username.' and return
    end
    @mod_request = ModRequest.new(
      user_id: @user.id,
      inviting_user_id: current_user.id,
      subphez_id: @subphez.id
    )
    if @mod_request.save
      redirect_to manage_subphez_path(path: @subphez.path),
                  notice: 'Moderator request sent.'
    else
      redirect_to manage_subphez_path(path: @subphez.path),
                  alert: 'Could not add moderator at this time.'
    end
  end

  def remove_moderator
    if !current_user.is_owner?(@subphez)
      redirect_to :back,
                  alert: 'You are not the owner of this subphez.' and return
    end
    @user = User.find(params[:user_id])
    if !@subphez.moderators.include?(@user)
      redirect_to :back,
                  alert: 'This user is not a moderator of this subphez.' and return
    end
    @moderation = Moderation.where(user_id: @user.id)
                  .where(subphez_id: @subphez.id).first
    @moderation.destroy
    redirect_to manage_subphez_path(path: @subphez.path),
                notice: 'Moderator removed.'
  end

  def approve_modrequest
    @mod_request = ModRequest
                   .where(user_id: current_user.id, subphez_id: @subphez.id)
                   .first
    if @mod_request.nil?
      redirect_to :back,
                  alert: 'Could not find add moderator request.' && return
    end
  end

  def update_modrequest
    @mod_request = ModRequest
                   .where(user_id: current_user.id, subphez_id: @subphez.id)
                   .first
    if @mod_request.nil?
      redirect_to :back,
                  alert: 'Could not find add moderator request.' and return
    end
    @subphez.add_moderator!(current_user)
    redirect_to manage_subphez_path(path: @subphez.path),
                notice: 'Success! You are now a moderator of this subphez.'
  end

  # GET /subphezs/new
  def new
    @subphez = Subphez.new
    if current_user.max_subphezes_reached?
      redirect_to root_path,
                  alert: "We're sorry, you have reached the maximum number of Subphezes allowable at this time. Please post content to and moderate your existing Subphezes, and we will consider lifting this limit soon." and return
    end
  end

  # GET /subphezs/1/edit
  def edit
  end

  # POST /subphezs
  # POST /subphezs.json
  def create
    if current_user.max_subphezes_reached?
      redirect_to root_path,
                  alert: "We're sorry, you have reached the maximum number of Subphezes allowable at this time. Please post content to and moderate your existing Subphezes, and we will consider lifting this limit soon." and return
    end
    @subphez = Subphez.new(subphez_params)
    @subphez.user_id = current_user.id
    if @subphez.save
        redirect_to view_subphez_path(path: @subphez.path),
                    notice: 'Subphez was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /subphezs/1
  # PATCH/PUT /subphezs/1.json
  def update
    if @subphez.update(subphez_params)
      redirect_to view_subphez_path(path: @subphez.path),
                  notice: 'Subphez was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /subphezs/1
  # DELETE /subphezs/1.json
  # def destroy
  #   @subphez.destroy
  #   respond_to do |format|
  #     format.html
  #       redirect_to subphezs_url,
  #       notice: 'Subphez was successfully destroyed.'
  #     format.json { head :no_content }
  #   end
  # end

  def random
    random_path = Subphez.pluck(:path).sample
    redirect_to view_subphez_path(path: random_path)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subphez
    @subphez = Subphez.find(params[:id])
  end

  def set_subphez_by_path
    @subphez = Subphez.by_path(params[:path])

    redirect_to root_path,
                alert: 'Could not find subphez.' and return if @subphez.nil?
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def subphez_params
    params.require(:subphez).permit(:path, :title, :sidebar)
  end
end
