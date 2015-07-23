module ApplicationHelper
  def title(title_text)
    content_for :title do
      raw(title_text)
    end
  end
end
