class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:my]

  def index
    to_show_premium = user_signed_in? ? current_user.is_premium : false
    @posts = Post.by_hot_score
             .show_premium(to_show_premium)
             .paginate(page: params[:page])
    @vote_hash = Vote.vote_hash(current_user, @posts)
    @newsletter_subscriber = NewsletterSubscriber.new
  end

  def my
    to_show_premium = user_signed_in? ? current_user.is_premium : false
    @posts = Post.my_phez(current_user, params[:page], to_show_premium)
    @vote_hash = Vote.vote_hash(current_user, @posts)
  end

  def latest
    to_show_premium = user_signed_in? ? current_user.is_premium : false
    @posts = Post.latest
             .show_premium(to_show_premium)
             .paginate(page: params[:page])
    @vote_hash = Vote.vote_hash(current_user, @posts)
  end

  def privacy
  end

  def thanks
  end

  def apidocs
  end
end
