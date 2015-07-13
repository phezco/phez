class Subphez < ActiveRecord::Base
  validates :path, format: { with: /\A[a-zA-Z0-9]+\Z/ }, length: {minimum: 1, maximum: 30}
  validates :title, presence: true

  has_many :posts
  has_many :moderations
  has_many :moderators, :through => :moderations

  scope :latest, -> { order('created_at DESC') }

  after_create :add_owner_as_moderator

  MaxPerUser = 3

  def sidebar_rendered
    return '' if sidebar.blank?
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(sidebar)
  end

  def owner?(the_user)
    the_user.id == user_id
  end

  def can_moderate?(the_user)
    moderators.include?(the_user)
  end

  def add_owner_as_moderator
    Moderation.create!(:user_id => user_id, :subphez_id => id)
  end

  def add_moderator!(new_moderator)
    Moderation.create!(:user_id => new_moderator.id, :subphez_id => id)
  end

  def self.by_path(path)
    Subphez.where("LOWER(path) = ?", path.downcase).first
  end

end
