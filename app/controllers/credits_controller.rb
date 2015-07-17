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
      # Get BTC Balance
      api_endpoint = "https://bitcoin.toshi.io/api/v0/addresses/#{Figaro.env.bitcoin_address}"
      balance_json = RestClient.get(api_endpoint)
      json = ActiveSupport::JSON.decode(balance_json)
      puts json.inspect
      @satoshi_balance = json['balance']
      @btc_balance = (@satoshi_balance.to_f / 100000000.0).round(5)
      @mbtc_balance = (@satoshi_balance.to_f / 100000.0).round(0)

      # Exchange Rate calculations
      ticker_endpoint = "https://www.bitstamp.net/api/ticker/"
      ticker_json = RestClient.get(ticker_endpoint)
      json = ActiveSupport::JSON.decode(ticker_json)
      @btc_in_usd = json['last'].to_f

      # Other Variables setup
      @fixed_costs_mbtc = ((Figaro.env.fixed_monthly_costs.to_f / @btc_in_usd) * 1000).round(0)
      @pool_available = (@mbtc_balance - (3 * @fixed_costs_mbtc)).round(0)
      @reward_top_percentage = 0.20
      @top_users_rewarded = ((@reward_top_percentage) * User.count.to_f).to_i
      puts "Top Users Rewarded count: #{@top_users_rewarded}"
      @top_users_limit = (@top_users_rewarded.to_f * 1.5).to_i
      puts "Top Users Limit: #{@top_users_limit}"

      # Setup Earnings Calculator
      @ec = EarningsCalculator.new(@pool_available, @reward_top_percentage, User.count)
    end
end