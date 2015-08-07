class RewardsController < ApplicationController
  before_action :authenticate_user!
  before_action :frozen_check!

  def new
    @reward = Reward.new
  end

  def premium
    @reward = Reward.new
    @reward.rewardable_type = params[:rewardable_type]
    @reward.rewardable_id = params[:rewardable_id]
  end

  def create
    @reward = Reward.new(reward_params)
    @reward.user = current_user
    @reward = set_reward_plan(params[:plan], true)
    @reward.funding_source = 'coinkite'
    if @reward.save
      coinkite_pay_url = setup_coinkite(@reward)
      redirect_to coinkite_pay_url
    else
      render action: :new,
             alert: 'There was a problem creating your Phez Premium transaction.'
    end
  end

  def create_rewardable
    @reward = Reward.new(reward_params)
    @reward.user = current_user
    if @reward.rewardable.nil? || @reward.rewardable.user.nil?
      flash[:alert] = 'There was a problem rewarding Phez Premium: post/comment or user not found'
      redirect_to(root_path) and return
    end
    if params[:plan] and params[:funding_source]
      flash[:alert] = 'Please select either your account as a funding source or a new premium purchase plan, but not both.'
      render(action: :premium) and return
    end

    if params[:plan]
      @reward = set_reward_plan(params[:plan])
      @reward.rewarded_user_id = @reward.rewardable.user.id
      @reward.funding_source = 'coinkite'
      if @reward.save
        coinkite_pay_url = setup_coinkite(@reward)
        redirect_to coinkite_pay_url
      else
        flash[:alert] = 'There was a problem creating your Phez Premium transaction.'
        render(action: :premium) and return
      end
    else
      # Rewarding Premium from existing account months
      if params[:months].blank?
        flash[:alert] = "Please select the number of premium months you'd like to give."
        render(action: :premium) and return
      end
      months = params[:months].to_i
      if months > current_user.rewardable_months
        flash[:alert] = "You cannot give more premium months than the number present in your account at this time: #{current_user.premium_months} months"
        render(action: :premium) and return
      end
      @reward.months = months
      @reward.amount_usd = Reward.cost(months)
      @reward.rewarded_user_id = @reward.rewardable.user.id
      @reward.payment_confirmed = true
      @reward.funding_source = 'internal'
      if @reward.save
        @reward.activate!
        redirect_to root_path, notice: "Success! You have rewarded #{@reward.rewardable.user.username} with Phez Premium."
      else
        flash[:alert] = 'There was a problem creating your Phez Premium transaction.'
        render action: :premium
      end
    end
  end

  def thanks
    @reward = Reward.where(id: params[:id]).first
    if @reward.nil?
      redirect_to(new_reward_path,
                  alert: 'Premium Reward purchase not found.') and return
    end
    @reward.activate!
  end

  private

  def reward_params
    params.require(:reward).permit(:rewardable_id, :rewardable_type)
  end

  def set_reward_plan(plan, _rewardable = false)
    case plan
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
    @reward
  end

  def setup_coinkite(reward)
    payload = {
      't' => reward.id,
      'p' => reward.amount_usd,
      'c' => 'USD',
      'r' => "http://#{Figaro.env.app_domain}/rewards/#{reward.id}/thanks"
    }
    token = JWT.encode payload, Figaro.env.coinkite_api_secret, 'HS256'
    "#{Figaro.env.coinkite_button_url}?#{token}"
  end
end
