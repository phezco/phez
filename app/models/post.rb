class Post < ActiveRecord::Base
  acts_as_commentable
  belongs_to :user
  belongs_to :subphez
  has_many :votes, dependent: :destroy

  validates :title, :presence => true

  scope :latest, -> { order('created_at DESC') }
  scope :by_points, -> { order('points DESC') }
  scope :by_hot_score, -> { order('hot_score DESC') }

  before_create :set_guid
  before_save :format_website_url
  after_create :add_vote
  before_save :sanitize_attributes

  self.per_page = 20

  def full_post_url
    "http://#{Figaro.env.app_domain}#{post_path}"
  end

  def post_path
    "/p/#{subphez.path}/#{id}/#{guid}"
  end

  def url_linkable
    return post_path if is_self
    self.url
  end

  def full_url
    return full_post_url if is_self
    self.url
  end

  def url_encoded
    return '' if url.blank?
    CGI.escape(self.url)
  end

  def domain
    return 'self' if is_self
    begin
      uri = URI.parse(url)
      uri.host.sub(/^www\./, '')
    rescue URI::InvalidURIError
      return 'unknown'
    end
  end

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
    self.guid = self.guid.blank? ? "post" : self.guid
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
    self.title = Sanitizer.sanitize(self.title) unless self.title.blank?
    self.body = Sanitizer.sanitize(self.body) unless self.body.blank?
    self.url = Sanitizer.sanitize(self.url) unless self.url.blank?
  end

  def self.my_phez(user, page = 1)
    subscribed_subphez_ids = user.subscribed_subphezes.map(&:id)
    where("subphez_id IN (?)", subscribed_subphez_ids).paginate(:page => page)
  end

  def self.suggest_title(url)
    suggested_title = ''
    begin
      rc = RestClient.get(url)
      if rc.headers && rc.headers[:content_type] && !rc.headers[:content_type].blank?
        content_type = rc.headers[:content_type].split(';')[0].strip
        if content_type == 'text/html'
          page = Nokogiri::HTML(rc)
          if page.css('title')
            suggested_title = page.css('title').text.strip
          end
        end
      end
    rescue Exception
    end
    suggested_title
  end

end
