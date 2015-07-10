class Subphez < ActiveRecord::Base
  validates :path, format: { with: /\A[a-zA-Z0-9]+\Z/ }, length: {minimum: 1, maximum: 30}
  validates :title, presence: true

  def sidebar_rendered
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(sidebar)
  end

  def owner?(the_user)
    the_user.id == user_id
  end

  def self.by_path(path)
    Subphez.where("LOWER(path) = ?", path.downcase).first
  end

end
