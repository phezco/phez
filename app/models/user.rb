class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :authentication_keys => [:username] #, :confirmable, :validatable

  validates :username, uniqueness: true
  validates :password, if: :password_present?, :presence => true, length: { minimum: 6, maximum: 100 }, :allow_blank => false, confirmation: true

  has_many :votes, dependent: :destroy
  has_many :moderations
  has_many :moderated_subphezes, :through => :moderations
  has_many :messages, dependent: :destroy
  has_many :posts
  has_many :comments
  has_many :subphezes
  has_many :subscriptions
  has_many :subscribed_subphezes, :through => :subscriptions

  validate :ensure_email_unique

  def password_present?
    !self.password.blank? && !self.password_confirmation.blank?
  end

  def monthly_comment_karma
    karma = comments.this_month.map {|p| p.vote_total }.inject(:+)
    karma.nil? ? 0 : karma
  end

  def monthly_link_karma
    karma = posts.this_month.map {|p| p.vote_total }.inject(:+)
    karma.nil? ? 0 : karma
  end

  def link_karma
    karma = posts.map {|p| p.vote_total }.inject(:+)
    karma.nil? ? 0 : karma
  end

  def comment_karma
    karma = comments.map {|c| c.vote_total }.inject(:+)
    karma.nil? ? 0 : karma
  end

  def max_subphezes_reached?
    return false if self.is_admin
    subphezes.count >= Subphez::MaxPerUser
  end

  def can_moderate?(subphez)
    subphez.moderators.include?(self)
  end

  def is_owner?(subphez)
    subphez.user_id == self.id
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def remember_me
    true
  end

  def inbox_read!
    update_attribute(:orange, false)
  end

  def self.by_username_insensitive(username)
    User.where('LOWER(username) = ?', username.downcase).first
  end

  def self.top_by_monthly_link_karma(limit = 100)
    users = User.all.map {|u| u }
    users.sort! { |a, b| b.monthly_link_karma <=> a.monthly_link_karma }[0 .. (limit-1)]
  end

  def self.top_by_monthly_moderation(limit = 100)
    mods = []
    subphezes = Subphez.top_by_subscriber_count(100)
    subphezes.each do |subphez|
      next if mods.size >= limit
      subphez.moderators.each do |mod|
        mods << mod
      end
    end
    mods.uniq
  end

  def self.top_by_monthly_comment_karma(limit = 100)
    users = User.all.map {|u| u }
    users.sort! { |a, b| b.monthly_comment_karma <=> a.monthly_comment_karma }[0 .. (limit-1)]
  end

  protected

    def ensure_email_unique
      return if email.blank?
      # Simple email validation for now
      if !email.include?('@')
        errors.add(:email, "does not appear to be valid. Missing the @ symbol?")
        return
      end
      if new_record?
        existing = User.where(email: email).first
        if existing
          errors.add(:email, "is already taken")
        end
      else
        existing = User.where(email: email).where.not(id: id).first
        if existing
          errors.add(:email, "is already taken")
        end
      end
    end

    def confirmation_required?
      false
    end

end
