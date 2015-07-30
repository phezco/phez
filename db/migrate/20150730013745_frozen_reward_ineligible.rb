class FrozenRewardIneligible < ActiveRecord::Migration
  def change
    add_column :users, :is_frozen, :boolean, default: false
    User.update_all(is_frozen: false)

    add_column :users, :is_reward_ineligible, :boolean, default: false
    User.update_all(is_reward_ineligible: false)
  end
end
