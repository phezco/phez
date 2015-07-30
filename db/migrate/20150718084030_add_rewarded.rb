class AddRewarded < ActiveRecord::Migration
  def change
    add_column :posts, :is_rewarded, :boolean, default: false
    Post.update_all(is_rewarded: false)

    add_column :comments, :is_rewarded, :boolean, default: false
    Comment.update_all(is_rewarded: false)
  end
end
