class Comment < ActiveRecord::Base
  include PgSearch
  multisearchable against: :body,
                  if: :not_premium

  acts_as_nested_set scope: [:commentable_id, :commentable_type]

  validates :body, presence: true
  validates :user, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comment_votes, dependent: :destroy

  scope :latest, -> { order('created_at DESC') }
  scope :this_month, -> do
    t = DateTime.now
    beginning_of_month = t.beginning_of_month
    end_of_month = t.end_of_month
    where('created_at >= :beginning_of_month AND created_at <= :end_of_month',
          beginning_of_month: beginning_of_month,
          end_of_month: end_of_month)
  end

  after_create :add_comment_upvote
  after_create :add_message_to_inbox_of_post_creator
  before_destroy :delete_messages!
  after_destroy :message_cleanup

  def not_premium
    !commentable.is_premium_only
  end

  def reward!
    update_attribute(:is_rewarded, true)
  end

  def url
    "#{commentable.full_post_url}##{id}"
  end

  def add_comment_upvote
    CommentVote.upvote(user, self)
  end

  def vote_total
    CommentVote.where(comment_id: id).sum(:vote_value)
  end

  def upvote_total
    CommentVote.where(comment_id: id).where('vote_value > 0').sum(:vote_value)
  end

  def downvote_total
    CommentVote
      .where(comment_id: id)
      .where('vote_value < 0')
      .sum(:vote_value) * -1
  end

  def delete!
    update_attribute(:user_id, nil)
    update_attribute(:body, nil)
    update_attribute(:is_deleted, true)
    delete_messages!
    comment_votes.delete_all
  end

  def owner?(check_user)
    check_user.id == user_id
  end

  def moderatable?(check_user)
    check_user.can_moderate?(commentable.subphez)
  end

  def body_rendered
    Renderer.render(body)
  end

  def add_message_to_inbox_of_post_creator
    Message
      .add_message_comment!(commentable.user,
                            self,
                            'new_post_comment') unless commentable.user == user
  end

  def add_reply_message
    parent_comment = parent
    if parent_comment && !(parent_comment.user == user)
      unless Message.messageable_inboxed?(parent_comment.user, self)
        Message.add_message_comment!(parent_comment.user, self, 'comment_reply')
      end
    end
  end

  def delete_messages!
    Message.delete_all(messageable_type: 'Comment', messageable_id: id)
  end

  def message_cleanup
    # Not ideal but other ways of deleting comment messages weren't working properly:
    m = Message.all.select {|m| m.messageable_id && m.messageable_type && m.messageable.nil? }
    m.map(&:destroy)
  end

  # Helper method to check if a comment has children
  def has_children?
    children.any?
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(user_id: user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable,
    lambda { |commentable_str, commentable_id|
      where(commentable_type: commentable_str.to_s,
            commentable_id: commentable_id)
        .order('created_at DESC')
    }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    new \
      commentable: obj,
      body: comment,
      user_id: user_id
  end
end
