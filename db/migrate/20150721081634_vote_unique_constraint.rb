class VoteUniqueConstraint < ActiveRecord::Migration
  def change
    add_index :votes, [:user_id, :post_id], unique: true
    add_index :comment_votes, [:user_id, :comment_id], unique: true
  end
end
