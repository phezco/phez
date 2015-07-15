class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :user, :presence => true

  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  has_many :comment_votes, dependent: :destroy

  scope :latest, -> { order('created_at DESC') }

  before_save :sanitize_attributes
  after_create :add_comment_upvote
  after_create :add_message_to_inbox

  def add_comment_upvote
    CommentVote.upvote(user, self)
  end

  def vote_total
    CommentVote.where(comment_id: self.id).sum(:vote_value)
  end

  def upvote_total
    CommentVote.where(comment_id: self.id).where('vote_value > 0').sum(:vote_value)
  end

  def downvote_total
    CommentVote.where(comment_id: self.id).where('vote_value < 0').sum(:vote_value) * -1
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
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true), autolink: true, tables: true)
    markdown.render(body)
  end

  def add_message_to_inbox
    Message.add_message_comment!(commentable.user, self) unless commentable.user == user
  end

  def delete_messages!
    Message.delete_all(:messageable_type => 'Comment', :messageable_id => self.id)
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.any?
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  def sanitize_attributes
    sanitizer = Rails::Html::FullSanitizer.new
    self.body = sanitizer.sanitize(self.body) unless self.body.blank?
  end

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
      :commentable => obj,
      :body        => comment,
      :user_id     => user_id
  end

end
