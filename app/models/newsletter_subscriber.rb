class NewsletterSubscriber < ActiveRecord::Base

  validates_format_of :email, with: Devise::email_regexp
  validates :email, uniqueness: true

  before_create :set_secret
  after_create :send_confirmation

  def send_confirmation
    Mailer.newsletter_confirmation(self).deliver_now!
  end

  def set_secret
    self.secret = SecureRandom.hex.slice(0, 10)
  end

  def self.send_newsletter
    puts "BEGIN: NewsletterSubscriber.send_newsletter"
    Ranker.pointify_daily!
    @posts = Post.order('daily_points DESC').limit(10)
    NewsletterSubscriber.where(is_confirmed: true).each do |newsletter_subscriber|
      #begin
        m = Mailer.newsletter(newsletter_subscriber, @posts).deliver_now!
        puts "Mailer.newsletter: #{m.inspect}"
      #rescue Exception => e
      #  puts "Rescued Exception: #{e.inspect}"
      #end
    end
  end

end
