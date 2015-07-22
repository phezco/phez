class CreditsController < ApplicationController
  before_action :authenticate_user!, :only => [:posters_csv]
  before_action :require_admin!, :except => [:leaderboard]
  before_action :setup_vars

  def posters_csv
    @top_posters = User.top_by_monthly_link_karma(@top_users_limit)
  end

  def leaderboard
    @top_posters = User.top_by_monthly_link_karma(@top_users_limit)
    @top_moderators = User.top_by_monthly_moderation(@top_users_limit)
    @top_commenters = User.top_by_monthly_comment_karma(@top_users_limit)
  end

  protected

    def setup_vars
      @btc_balance, @mbtc_balance = *PhezBitcoin.balance

      @btc_in_usd = PhezBitcoin.btc_in_usd

      # Other Variables setup
      @fixed_costs_mbtc = ((Figaro.env.fixed_monthly_costs.to_f / @btc_in_usd) * 1000).round(0)
      @pool_available = (@mbtc_balance - (3 * @fixed_costs_mbtc)).round(0)
      @reward_top_percentage = 0.20
      @top_users_rewarded = ((@reward_top_percentage) * User.count.to_f).to_i
      @top_users_limit = (@top_users_rewarded.to_f * 1.5).to_i

      # Setup Earnings Calculator
      @ec = EarningsCalculator.new(@pool_available, @reward_top_percentage, User.count)
    end
end