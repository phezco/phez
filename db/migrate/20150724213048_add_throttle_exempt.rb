class AddThrottleExempt < ActiveRecord::Migration
  def change
    add_column :users, :throttle_exempt, :boolean, default: false
    User.update_all(throttle_exempt: false)
  end
end
