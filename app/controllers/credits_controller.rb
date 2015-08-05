class CreditsController < ApplicationController
  before_action :authenticate_user!, except: [:leaderboard]
  before_action :require_admin!, except: [:leaderboard]
  before_action :setup_vars
  before_action :setup_users
  before_filter :setup_earnings_hash, except: [:leaderboard]

  def transactions
  end

  def create_transactions
    @earnings_hash.each do |user_id, mbtc|
      next if mbtc == 0
      user = User.find(user_id)
      txn = Transaction.create!(user_id: user.id,
                                amount_mbtc: mbtc,
                                txn_type: 'content')
    end
    redirect_to root_path, notice: 'Transactions created.'
  end

  def leaderboard
  end

  protected

  def setup_vars
    @btc_balance, @mbtc_balance = *PhezBitcoin.balance

    @btc_in_usd = PhezBitcoin.btc_in_usd

    # Other Variables setup
    @fixed_costs_mbtc = (
      (Figaro.env.fixed_monthly_costs.to_f / @btc_in_usd) * 1000
    ).round(0)
    @pool_available = (@mbtc_balance - (3 * @fixed_costs_mbtc)).round(0)
    @reward_top_percentage = 0.20
    @top_users_rewarded = ((@reward_top_percentage) * User.count.to_f).to_i
    @top_users_limit = (@top_users_rewarded.to_f * 1.5).to_i

    @sub_pool_percentage = 0.166
    @total_mbtc_per_subpool = (@sub_pool_percentage * @pool_available).round(0)

    # Setup Earnings Calculator
    @ec = EarningsCalculator.new(@pool_available,
                                 @reward_top_percentage,
                                 User.count,
                                 @total_mbtc_per_subpool)
  end

  def setup_users
    @top_posters = User.top_by_monthly_link_karma(@top_users_limit)
    @top_moderators = User.top_by_monthly_moderation(@top_users_limit)
    @top_commenters = User.top_by_monthly_comment_karma(@top_users_limit)
  end

  def setup_earnings_hash
    @earnings_hash = {}
    i = 1
    @top_posters.each do |u|
      mbtc = @ec.calculate_mbtc_earnings(@sub_pool_percentage, i)
      @earnings_hash[u.id] = mbtc
      i += 1
    end
    i = 1
    @top_moderators.each do |u|
      mbtc = @ec.calculate_mbtc_earnings(@sub_pool_percentage, i)
      if @earnings_hash[u.id]
        @earnings_hash[u.id] += mbtc
      else
        @earnings_hash[u.id] = mbtc
      end
      i += 1
    end
    i = 1
    @top_commenters.each do |u|
      mbtc = @ec.calculate_mbtc_earnings(@sub_pool_percentage, i)
      if @earnings_hash[u.id]
        @earnings_hash[u.id] += mbtc
      else
        @earnings_hash[u.id] = mbtc
      end
      i += 1
    end
  end
end
