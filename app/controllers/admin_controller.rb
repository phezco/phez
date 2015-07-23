class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @post_count = Post.count
    @user_count = User.count
    @subphez_count = Subphez.count
    @comment_count = Comment.count
    @users = User.latest.limit(10)
    @comments = Comment.latest.limit(10)
  end

  def payments_csv
    setup_payable_users
    render :layout => false
  end

  def microtip_csv
    @users = User.all.select { |u| !u.bitcoin_address.blank? }
    @microtip = 1
    render :layout => false
  end

  private

    def setup_payable_users
      @payable = []
      User.all.each do |user|
        @payable << user if (user.balance > 0) && !user.bitcoin_address.blank?
      end
    end
end