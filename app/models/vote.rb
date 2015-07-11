class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  scope :last_thirtysix_hours, lambda { where('created_at > ?', 36.hours.ago) }

  def upvote?
    vote_value == 1
  end

  def downvote?
    !upvote?
  end

  def self.voted(user, post)
    Vote.where(user_id: user.id).where(post_id: post.id).first
  end

  def self.destroy_vote(user, post)
    current_vote = Vote.where(user_id: user.id).where(post_id: post.id).first
    current_vote.destroy if current_vote
  end

  def self.upvote(user, post)
    destroy_vote(user, post)
    Vote.create(user_id: user.id, post_id: post.id, vote_value: 1)
  end

  def self.downvote(user, post)
    destroy_vote(user, post)
    Vote.create(user_id: user.id, post_id: post.id, vote_value: -1)
  end

end
