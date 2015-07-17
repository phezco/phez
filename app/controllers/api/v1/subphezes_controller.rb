class Api::V1::SubphezesController < Api::V1::BaseController
  before_action :set_subphez_by_path, :except => [:top]

  def top
    @subphezes = Subphez.top_by_subscriber_count(100)
    render json: @subphezes, each_serializer: SubphezSerializer
  end

  def all
    @posts = @subphez.posts.by_hot_score.paginate(:page => params[:page])
    render json: @posts, each_serializer: PostSerializer
  end

  def latest
    @posts = @subphez.posts.latest.paginate(:page => params[:page])
    render json: @posts, each_serializer: PostSerializer
  end


  private

    def set_subphez_by_path
      @subphez = Subphez.by_path(params[:path])
      if @subphez.nil?
        render json: errors_json("Could not find subphez: #{params[:path]}"), status: :not_found and return
      end
    end


end