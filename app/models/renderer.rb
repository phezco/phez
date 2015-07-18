class Renderer

  def self.render(text)
   markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true), autolink: true, tables: true, fenced_code_blocks: true)
   markdown.render(text)
  end

end