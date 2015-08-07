class Api::V1::SubphezesController < Api::V1::BaseController
  before_action :set_subphez_by_path, except: [:top]
  before_action :doorkeeper_authorize!, only: [:subscribe, :unsubscribe]
  before_action :authenticate_user!, only: [:subscribe, :unsubscribe]

  def top
    @subphezes = Subphez.top_by_subscriber_count(100)
    render json: @subphezes, each_serializer: SubphezSerializer
  end

  def all
    api_disallow_non_premium(@subphez)
    @posts = @subphez.posts.by_hot_score.paginate(page: params[:page])
    render json: @posts, each_serializer: PostSerializer
  end

  def latest
    api_disallow_non_premium(@subphez)
    @posts = @subphez.posts.latest.paginate(page: params[:page])
    render json: @posts, each_serializer: PostSerializer
  end

  def subscribe
    api_disallow_non_premium(@subphez)
    subscription = Subscription.subscribe!(@subphez, current_resource_owner)
    if subscription
      json = { 'success' => true }
      render json: json
    else
      json = { 'success' => false, 'errors' => 'already subscribed' }
      render json: json
    end
  end

  def unsubscribe
    subscription = Subscription.unsubscribe!(@subphez, current_resource_owner)
    if subscription
      json = { 'success' => true }
      render json: json
    else
      json = { 'success' => false, 'errors' => 'not subscribed' }
      render json: json
    end
  end

  private

  def set_subphez_by_path
    @subphez = Subphez.by_path(params[:path])
    if @subphez.nil?
      render(json: errors_json("Could not find subphez: #{params[:path]}"), status: :not_found) and return
    end
  end
end
