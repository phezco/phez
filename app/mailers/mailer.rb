class Mailer < ActionMailer::Base
  default from: "\"Phez\" <no-reply@#{Figaro.env.app_domain}>"

  layout 'mailer'

  def newsletter(newsletter_subscriber, posts)
    @posts = posts
    @subscriber = newsletter_subscriber
    @date_str = DateTime.now.strftime("%B %e, %Y")
    mail to: @subscriber.email,
         subject: "Phez Top Posts for #{@date_str}"
  end

  def newsletter_confirmation(newsletter_subscriber)
    @subscriber = newsletter_subscriber
    mail to: @subscriber.email,
         subject: "[Phez] Please confirm your email address"
  end

end
