class RemoveCommentConstraint < ActiveRecord::Migration
  def change
    change_column_null :comments, :user_id, true
  end
end
