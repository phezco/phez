class AddDailyPointsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :daily_points, :integer, default: 0
    Post.update_all(daily_points: 0)
  end
end
