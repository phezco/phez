class Post < ActiveRecord::Base
  include PgSearch
  multisearchable against: [:title, :url, :body],
                  if: :not_premium

  acts_as_commentable
  belongs_to :user
  belongs_to :subphez
  has_many :votes, dependent: :destroy

  validates :title, presence: true
  validate :url_and_body_cant_both_be_blank

  scope :latest, -> { order('created_at DESC') }
  scope :by_points, -> { order('points DESC') }
  scope :by_hot_score, -> { order('hot_score DESC') }
  scope :this_month, lambda {
    t = DateTime.now
    beginning_of_month = t.beginning_of_month
    end_of_month = t.end_of_month
    where('created_at >= :beginning_of_month AND created_at <= :end_of_month',
          beginning_of_month: beginning_of_month,
          end_of_month: end_of_month)
  }

  scope :show_premium, lambda { |to_show_premium|
    where(is_premium_only: false) unless to_show_premium
  }

  before_create :set_guid
  before_save :format_website_url
  after_create :add_vote
  before_save :sanitize_attributes

  self.per_page = 20

  def not_premium
    !is_premium_only
  end

  def reward!
    update_attribute(:is_rewarded, true)
  end

  def full_post_url
    "http://#{Figaro.env.app_domain}#{post_path}"
  end

  def post_path
    "/p/#{subphez.path}/#{id}/#{guid}"
  end

  def url_linkable
    return post_path if is_self
    url
  end

  def full_url
    return full_post_url if is_self
    url
  end

  def url_encoded
    return '' if url.blank?
    CGI.escape(url)
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
    Vote.where(post_id: id).sum(:vote_value)
  end

  def upvote_total
    Vote.where(post_id: id).where('vote_value > 0').sum(:vote_value)
  end

  def downvote_total
    Vote.where(post_id: id).where('vote_value < 0').sum(:vote_value) * -1
  end

  def comment_count
    Comment.where(commentable_id: id).count
  end

  def format_website_url
    if !url.blank?
      return if url.include?('http://') || url.include?('https://')
      self.url = "http://#{url}"
    end
  end

  def body_rendered
    Renderer.render(body)
  end

  def editable?
    return false unless is_self
    return true if created_at > 1.day.ago
    return false
  end

  def set_guid
    self.guid = title.downcase.gsub(' ', '-').gsub(/[^0-9a-z\- ]/i, '')
    self.guid = guid.blank? ? 'post' : guid
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
    self.title = Sanitizer.sanitize(title) unless title.blank?
    self.url = Sanitizer.sanitize(url) unless url.blank?
  end

  def url_and_body_cant_both_be_blank
    if url.blank? && body.blank?
      errors.add(:url, "can't be blank if body is blank")
      errors.add(:body, "can't be blank if url is blank")
    end
  end

  def self.my_phez(user, page = 1, to_show_premium = false)
    subscribed_subphez_ids = user.subscribed_subphezes.map(&:id)
    show_premium(to_show_premium)
      .where('subphez_id IN (?)', subscribed_subphez_ids)
      .paginate(page: page)
  end

  def self.suggest_title(url)
    suggested_title = ''
    begin
      rc = RestClient.get(url)
      if rc.headers && rc.headers[:content_type] &&
         !rc.headers[:content_type].blank?

        content_type = rc.headers[:content_type].split(';')[0].strip
        if content_type == 'text/html'
          page = Nokogiri::HTML(rc)
          suggested_title = page.css('title').text.strip if page.css('title')
        end
      end
    rescue Exception
    end
    suggested_title
  end
end
