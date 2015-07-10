class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :subphez

  before_create :set_guid

  before_save :format_website_url

  def format_website_url
    if !url.blank?
      return if url.include?('http://') || url.include?('https://')
      self.url = "http://#{self.url}"
    end
  end

  def body_rendered
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
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

end
