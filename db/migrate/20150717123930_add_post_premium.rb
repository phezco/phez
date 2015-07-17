class AddPostPremium < ActiveRecord::Migration
  def change
    add_column :posts, :is_premium_only, :boolean, default: false
    Post.update_all(:is_premium_only => false)
  end
end
