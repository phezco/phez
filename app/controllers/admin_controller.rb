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
    render layout: false
  end

  def generate_payment_transactions
    setup_payable_users
    @payable.each do |user|
      Transaction.create!(user_id: user.id,
                          amount_mbtc: (user.balance * -1),
                          txn_type: 'payment',
                          bitcoin_address: user.bitcoin_address)
    end
    redirect_to admin_index_path, notice: 'Payment transactions generated.'
  end

  def microtip_csv
    @users = User.all.select { |u| !u.bitcoin_address.blank? }
    @microtip = 1
    render layout: false
  end

  def transactions
    @transactions = Transaction.order('created_at DESC').all
    @transaction = Transaction.new
  end

  def create_transaction
    @transaction = Transaction.new(transaction_params)
    @user = User.by_username_insensitive(params[:username])
    if @user.nil?
      render(action: :transactions,
             alert: "Could not find user with username: #{params[:username]}") and return
    end
    @transaction.user = @user
    if @transaction.save
      redirect_to transactions_admin_index_path,
                  notice: 'Transaction successfully created.'
    else
      render action: :transactions,
             alert: 'There was a problem creating the transaction.'
    end
  end

  def users
    @users = User.latest.all.paginate(page: params[:page])
  end

  def freeze
    user = User.find(params[:id])
    user.update_attribute(:is_frozen, true)
    redirect_to users_admin_index_path, notice: 'User frozen.'
  end

  def unfreeze
    user = User.find(params[:id])
    user.update_attribute(:is_frozen, false)
    redirect_to users_admin_index_path, notice: 'User thawed (unfrozen).'
  end

  def make_ineligible
    user = User.find(params[:id])
    user.update_attribute(:is_reward_ineligible, true)
    redirect_to users_admin_index_path, notice: 'User is no longer eligible for rewards.'
  end

  def make_eligible
    user = User.find(params[:id])
    user.update_attribute(:is_reward_ineligible, false)
    redirect_to users_admin_index_path, notice: 'User is now eligible for rewards.'
  end

  private

  def setup_payable_users
    @payable = []
    User.all.each do |user|
      @payable << user if (user.balance > 0) and !user.bitcoin_address.blank?
    end
  end

  def transaction_params
    params.require(:transaction).permit(:amount_mbtc, :txn_type)
  end
end
