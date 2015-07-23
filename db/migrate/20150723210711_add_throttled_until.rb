class AddThrottledUntil < ActiveRecord::Migration
  def change
    add_column :users, :throttled_until, :datetime
  end
end
