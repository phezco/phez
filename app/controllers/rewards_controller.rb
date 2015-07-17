class RewardsController < ApplicationController
  before_action :authenticate_user!

  def new
    @reward = Reward.new
  end

  def premium
    @reward = Reward.new
  end

  def create
    @reward = Reward.new(reward_params)
    @reward.user = current_user
    case params[:plan]
    when 'one_month'
      @reward.amount_usd = Reward.cost(1)
      @reward.months = 1
    when 'three_months'
      @reward.amount_usd = Reward.cost(3)
      @reward.months = 3
    when 'six_months'
      @reward.amount_usd = Reward.cost(6)
      @reward.months = 6
    when 'one_year'
      @reward.amount_usd = Reward.cost(12)
      @reward.months = 12
    when 'custom'
      @reward.amount_usd = params[:custom_amount]
      @reward.months = Reward.months_given_cost(params[:custom_amount])
    end
    
    if @reward.save
      payload = {'t' => @reward.id, 'p' => @reward.amount_usd, 'c' => 'USD', 'r' => "http://#{Figaro.env.app_domain}/rewards/#{@reward.id}/thanks"}
      token = JWT.encode payload, Figaro.env.coinkite_api_secret, 'HS256'
      coinkite_pay_url = "#{Figaro.env.coinkite_button_url}?#{token}"
      redirect_to coinkite_pay_url
    else
      flash[:alert] = "There was a problem creating your Phez Premium transaction."
      render :action => :new
    end
  end

  def thanks
    @reward = Reward.where(id: params[:id]).first
    if @reward.nil?
      redirect_to new_reward_path, alert: 'Premium Reward purchase not found.' and return
    end
    @reward.activate!
  end

  private

    def reward_params
      params.require(:reward).permit(:rewardable_id, :rewardable_type)
    end

end