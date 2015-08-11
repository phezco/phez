class Subphez < ActiveRecord::Base
  validates :path,
            format: { with: /\A[a-zA-Z0-9]+\Z/ },
            length: { minimum: 1, maximum: 30 },
            uniqueness: { case_sensitive: false }
  validates :title, presence: true

  belongs_to :user
  has_many :posts
  has_many :moderations
  has_many :moderators, through: :moderations
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions

  scope :latest, -> { order('created_at DESC') }

  before_save :sanitize_attributes
  after_create :add_owner_as_moderator
  after_create :subscribe_creator

  MaxPerUser = 3

  def url
    "http://#{Figaro.env.app_domain}/p/#{path}"
  end

  def atom_feed
    "#{url}.atom"
  end

  def subscriber_count
    Subscription.where(subphez_id: id).count
  end

  def sidebar_rendered
    return '' if sidebar.blank?
    Renderer.render(sidebar)
  end

  def owner?(the_user)
    the_user.id == user_id
  end

  def can_moderate?(the_user)
    moderators.include?(the_user)
  end

  def add_owner_as_moderator
    Moderation.create!(user_id: user_id, subphez_id: id)
  end

  def add_moderator!(new_moderator)
    Moderation.create!(user_id: new_moderator.id, subphez_id: id)
  end

  def subscribe_creator
    Subscription.subscribe!(self, user)
  end

  def sanitize_attributes
    self.title = Sanitizer.sanitize(title) unless title.blank?
    self.sidebar = Sanitizer.sanitize(sidebar) unless sidebar.blank?
  end

  def self.by_path(path)
    Subphez.where('LOWER(path) = ?', path.downcase).first
  end

  def self.top_by_subscriber_count(limit = 100)
    subphezes = Subphez.all
    subphezes = subphezes.map { |s| s }.sort! { |a, b| b.subscriber_count <=> a.subscriber_count }
    subphezes[0..(limit - 1)]
  end
end
