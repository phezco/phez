class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :authentication_keys => [:username] #, :confirmable, :validatable

  validates :username, uniqueness: true

  has_many :votes, dependent: :destroy
  has_many :moderations
  has_many :moderated_subphezes, :through => :moderations
  has_many :messages, dependent: :destroy
  has_many :posts
  has_many :comments

  validate :ensure_email_unique

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
    update(orange: false)
  end

  def self.by_username_insensitive(username)
    User.where('LOWER(username) = ?', username.downcase).first
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
