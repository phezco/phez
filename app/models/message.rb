class Message < ActiveRecord::Base

  default_scope { order('created_at DESC') } 

  belongs_to :user
  belongs_to :from_user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :messageable, polymorphic: true

  validates :user, presence: true
  validates :body, presence: true
  after_create :set_orange
  before_save :sanitize_attributes

  self.per_page = 20

  def body_rendered
    Renderer.render(body)
  end

  def sanitize_attributes
    self.title = Sanitizer.sanitize(self.title) unless self.title.blank?
  end

  def self.add_message_comment!(user, comment, reason)
    message = Message.new(user: user, messageable: comment, reason: reason)
    message.save(validate: false)
    message.set_orange
  end

  def self.messageable_inboxed?(user, messageable)
    Message.where(user_id: user.id, messageable_type: messageable.class.to_s, messageable_id: messageable.id).any?
  end

  def set_orange
    user.update_attribute(:orange, true)
  end

end