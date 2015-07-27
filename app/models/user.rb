class User < ActiveRecord::Base
  include PgSearch
  multisearchable against: :username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, authentication_keys: [:username]

  validates :username, uniqueness: true, length: { minimum: 1, maximum: 30 }, presence: true, allow_blank: false
  validates :password, if: :password_present?, presence: true, length: { minimum: 6, maximum: 100 }, allow_blank: false, confirmation: true
  validates :bitcoin_address, format: { with: /\A(1|3)[a-zA-Z1-9]{26,33}\z/, message: "is invalid" }, allow_blank: true

  has_many :votes, dependent: :destroy
  has_many :moderations, dependent: :destroy
  has_many :moderated_subphezes, through: :moderations
  has_many :messages, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subphezes, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_subphezes, through: :subscriptions
  has_many :transactions, dependent: :destroy
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner, dependent: :destroy

  scope :latest, -> { order('created_at DESC') }

  validate :ensure_email_unique

  before_create :set_secret

  def set_secret
    self.secret = SecureRandom.hex.slice(0, 10)
  end

  def set_secret!
    set_secret
    update_attribute(:secret, self.secret)
  end

  def balance
    transactions.sum(:amount_mbtc)
  end

  def balance_in_bitcoin
    balance / 1000.0
  end

  def has_rewardable_months?
    rewardable_months > 0
  end

  def reward!(reward)
    rewardable = (reward.funding_source == 'coinkite')
    if reward.rewarded_user
      if reward.funding_source == 'internal'
        reward.user.subtract_premium_months!(reward.months)
      end
      if reward.rewarded_user.is_premium
        reward.rewarded_user.add_premium_months!(reward.months, false)
      else
        reward.rewarded_user.update(is_premium: true, premium_since: DateTime.now, premium_until: 1.month.from_now)
        reward.rewarded_user.add_premium_months!(reward.months - 1, false)
      end
      Transaction.reward!(reward)
    else
      if is_premium
        # Already Premium - do not debit a premium month. Add all new reward months to this user's premium month count:
        add_premium_months!(reward.months, rewardable)
      else
        update(is_premium: true, premium_since: DateTime.now, premium_until: 1.month.from_now)
        add_premium_months!(reward.months - 1, rewardable)
      end
    end
  end

  def add_premium_months!(new_month_count, rewardable)
    self.premium_months += new_month_count
    self.rewardable_months += new_month_count if rewardable
    save
  end

  def subtract_premium_months!(num_months_to_debit)
    self.premium_months -= num_months_to_debit
    self.rewardable_months -= num_months_to_debit
    save
  end

  def revoke_premium!
    update(is_premium: false, premium_since: nil, premium_until: nil)
  end

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
    users.sort! { |a, b| b.monthly_link_karma <=> a.monthly_link_karma }.reject {|u| u.is_admin}[0 .. (limit-1)]
  end

  def self.top_by_monthly_moderation(limit = 100)
    mods = []
    subphezes = Subphez.top_by_subscriber_count(100)
    subphezes.each do |subphez|
      next if mods.size >= limit
      subphez.moderators.each do |mod|
        mods << mod unless mod.is_admin
      end
    end
    mods.uniq
  end

  def self.top_by_monthly_comment_karma(limit = 100)
    users = User.all.map {|u| u }
    users.sort! { |a, b| b.monthly_comment_karma <=> a.monthly_comment_karma }.reject {|u| u.is_admin}[0 .. (limit-1)]
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
