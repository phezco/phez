class AddRewardableMonths < ActiveRecord::Migration
  def change
    add_column :users, :rewardable_months, :integer, :default => 0
    User.update_all(:rewardable_months => 0)

    add_column :rewards, :funding_source, :string
  end
end
