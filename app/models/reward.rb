class Reward < ActiveRecord::Base

  validates :user, presence: true
  validates :months, presence: true, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :amount_usd, presence: true, :numericality => { :greater_than_or_equal_to => Figaro.env.premium_cost_per_month.to_f }

  belongs_to :user
  belongs_to :rewarded_user, :class_name => 'User', :foreign_key => 'rewarded_user_id'
  belongs_to :rewardable, :polymorphic => true

  def activate!
    user.reward!(self)
    rewardable.reward! if rewardable
  end

  def deliver_message(txn)
    Message.create!(user_id: rewarded_user_id, title: "You have been rewarded Phez Premium by #{user.username}",
      body: "Congratulations!\n\nYou have been rewarded Phez Premium and #{txn.amount_mbtc} mBTC has been credited to your account.\n\nAt the end of the month, your balance of earned bitcoin will be swept into the bitcoin address you have setup under My Account.")
  end

  def self.months_given_cost(cost)
    (cost.to_f / Figaro.env.premium_cost_per_month.to_f).to_i
  end

  def self.cost(months = 1)
    base_cost = (Figaro.env.premium_cost_per_month.to_f * months).to_f
    cost = base_cost
    if months == 6
      cost = base_cost * 0.90
    end
    if months >= 12
      cost = base_cost * 0.75
    end
    cost
  end

end