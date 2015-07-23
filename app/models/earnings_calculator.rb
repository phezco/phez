class EarningsCalculator

  def initialize(pool_available, reward_top_percentage, global_user_count)
    @pool_available = pool_available
    @reward_top_percentage = reward_top_percentage
    @global_user_count = global_user_count
    @num_users_eligible = (@reward_top_percentage * @global_user_count.to_f).to_i
  end

  def calculate_mbtc_earnings(sub_pool_percentage, rank)
    return 0 if rank >= @num_users_eligible
    sub_percentage = sub_percentage_by_rank(rank)
    mbtc = sub_percentage * sub_pool_percentage * @pool_available.to_f
    mbtc.round.to_i
  end

  # This needs to be updated as the site grows to keep the distribution fairly logarithmic
  def sub_percentage_by_rank(rank)
    case rank
    when 1
      return 0.25
    when 2
      return 0.20
    when 3
      return 0.15
    when 4
      return 0.10
    when 5
      return 0.05
    else
      # If you update any of the above values, you MUST update the value below.
      #  They should equal a total of 1 for 100%.
      return 0.25 / @num_users_eligible.to_f
    end
  end

end