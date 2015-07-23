class Transaction < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  TxnTypes = ['reward', 'content', 'development', 'misc']

  def credit?
    amount_mbtc > 0
  end

  def self.txn_types_for_select
    TxnTypes.map { |txn_type| [txn_type, txn_type] }
  end

  def self.reward!(reward)
    btc_in_usd = PhezBitcoin.btc_in_usd
    reward_in_usd = Reward.cost(reward.months) * 0.5
    amount_mbtc = (( reward_in_usd / btc_in_usd.to_f) * 1000.0).round(0)
    txn = Transaction.create!(:user_id => reward.rewarded_user_id,
                              :amount_mbtc => amount_mbtc,
                              :txn_type => 'reward')
    reward.deliver_message(txn)
  end

end