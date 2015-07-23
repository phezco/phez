# Enables voting on comments
class CommentVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  def upvote?
    vote_value == 1
  end

  def downvote?
    !upvote?
  end

  def self.voted(user, comment)
    CommentVote.where(user_id: user.id).where(comment_id: comment.id).first
  end

  def self.destroy_vote(user, comment)
    current_vote = CommentVote.where(user_id: user.id)
                   .where(comment_id: comment.id)
                   .first
    current_vote.destroy if current_vote
  end

  def self.upvote(user, comment)
    destroy_vote(user, comment)
    CommentVote.create(user_id: user.id, comment_id: comment.id, vote_value: 1)
  end

  def self.downvote(user, comment)
    destroy_vote(user, comment)
    CommentVote.create(user_id: user.id, comment_id: comment.id, vote_value: -1)
  end
end
