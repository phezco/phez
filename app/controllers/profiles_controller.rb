class ProfilesController < ApplicationController
  before_filter :set_by_username

  def show
    @posts = @user.posts.latest.paginate(:page => params[:page])
  end

  def comments
    @comments = @user.comments.latest.paginate(:page => params[:page])
  end

private

  def set_by_username
    @user = User.where(username: params[:id]).first
    if @user.nil?
      redirect_to root_path, alert: 'Could not find user.' and return
    end
  end


end