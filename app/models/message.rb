class Message < ActiveRecord::Base

  default_scope { order('created_at DESC') } 

  belongs_to :user
  belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'

  validates :user, :presence => true
  validates :body, :presence => true
  after_create :set_orange
  before_save :sanitize_attributes

  def body_rendered
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true), autolink: true, tables: true)
    markdown.render(body)
  end

  def sanitize_attributes
    self.title = sanitize(self.title) unless self.title.blank?
    self.body = sanitize(self.body) unless self.body.blank?
  end

  def sanitize(text)
    return '' if text.blank?
    sanitizer = Rails::Html::FullSanitizer.new
    # Sanitizer seems to be inserting "&#13;" into the text around newlines. Not sure why. For now:
    sanitizer.sanitize(text).gsub('&#13;', '')
  end

protected

  def set_orange
    user.update_attribute(:orange, true)
  end

end