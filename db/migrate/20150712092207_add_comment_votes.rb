class AddCommentVotes < ActiveRecord::Migration
  def change
    create_table :comment_votes do |t|
      t.integer :user_id, null: false
      t.integer :comment_id, null: false
      t.integer :vote_value, null: false

      t.datetime :created_at, null: false
    end
  end
end
