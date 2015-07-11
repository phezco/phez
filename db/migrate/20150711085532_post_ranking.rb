class PostRanking < ActiveRecord::Migration
  def change
    add_column :posts, :points, :integer, default: 0
    add_column :posts, :hot_score, :integer, default: 0
  end
end
