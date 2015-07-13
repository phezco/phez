class Post < ActiveRecord::Base
  acts_as_commentable
  belongs_to :user
  belongs_to :subphez
  has_many :votes, dependent: :destroy

  scope :latest, -> { order('created_at DESC') }
  scope :by_points, -> { order('points DESC') }
  scope :by_hot_score, -> { order('hot_score DESC') }

  before_create :set_guid
  before_save :format_website_url
  after_create :add_vote
  before_save :sanitize_attributes

  self.per_page = 20

  def vote_total
    Vote.where(post_id: self.id).sum(:vote_value)
  end

  def upvote_total
    Vote.where(post_id: self.id).where('vote_value > 0').sum(:vote_value)
  end

  def downvote_total
    Vote.where(post_id: self.id).where('vote_value < 0').sum(:vote_value) * -1
  end

  def comment_count
    Comment.where(commentable_id: self.id).count
  end

  def format_website_url
    if !url.blank?
      return if url.include?('http://') || url.include?('https://')
      self.url = "http://#{self.url}"
    end
  end

  def body_rendered
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true), autolink: true, tables: true)
    markdown.render(body)
  end

  def editable?
    return false unless is_self
    return true if created_at > 1.day.ago
    return false
  end

  def set_guid
    self.guid = title.downcase.gsub(' ', '-').gsub(/[^0-9a-z\- ]/i, '')
  end

  def owner?(the_user)
    the_user.id == user_id
  end

  def moderateable?(the_user)
    subphez.can_moderate?(the_user)
  end

  def add_vote
    Vote.upvote(user, self)
  end

  def sanitize_attributes
    self.title = sanitize(self.title) unless self.title.blank?
    self.body = sanitize(self.body) unless self.title.blank?
    self.url = sanitize(self.url) unless self.title.blank?
  end

  def sanitize(text)
    sanitizer = Rails::Html::FullSanitizer.new
    # Sanitizer seems to be inserting "&#13;" into the text around newlines. Not sure why. For now:
    sanitizer.sanitize(text).gsub('&#13;', '')
  end

end
