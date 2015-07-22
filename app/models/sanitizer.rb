class Sanitizer
  def self.sanitize(text)
    return '' if text.blank?
    sanitizer = Rails::Html::FullSanitizer.new
    # FullSanitizer seems to be inserting "&#13;" into the text around newlines. Not sure why. For now:
    text = sanitizer.sanitize(text).gsub('&#13;', '')
    # To support markdown blockquotes, re-insert escaped greater than symbols:
    text.gsub('&gt;', '>')
  end
end