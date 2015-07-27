class AddRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :user_id
      t.float :amount_usd
      t.float :amount_mbtc
      t.integer :confirmations_count, default: 0, null: false
      t.integer :rewarded_user_id
      t.integer :rewardable_id
      t.string :rewardable_type
      t.integer :months
      t.boolean :payment_confirmed, default: false, null: false
      t.timestamps
    end

    add_column :users, :is_premium, :boolean, deafault: false
    User.update_all(is_premium: false)

    add_column :users, :premium_months, :integer, default: 0
    User.update_all(premium_months: 0)

    add_column :users, :premium_since, :datetime
    add_column :users, :premium_until, :datetime

    add_column :subphezes, :is_premium_only, :boolean, default: false
    Subphez.update_all(is_premium_only: false)

  end
end
