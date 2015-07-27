class NewsletterSubscriber < ActiveRecord::Base

  validates_format_of :email, :with => Devise::email_regexp
  validates :email, uniqueness: true

  before_create :set_secret

  def set_secret
    self.secret = SecureRandom.hex.slice(0, 10)
  end

  def self.send_newsletter!
    Ranker.pointify_daily!
    @posts = Post.order('daily_points DESC').limit(10)
    NewsletterSubscriber.where(is_confirmed: true).each do |newsletter_subscriber|
      begin
        m = Mailer.newsletter(newsletter_subscriber, @posts).deliver_now!
      rescue Exception
      end
    end
  end

end
