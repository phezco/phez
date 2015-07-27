class Mailer < ActionMailer::Base
  default from: "\"Phez\" <no-reply@#{Figaro.env.app_domain}>"
  add_template_helper(ApplicationHelper)

  layout 'mailer'

  def newsletter(newsletter_subscriber, posts)
    @posts = posts
    @subscriber = newsletter_subscriber
    # Assume server time is UTC so use 1 day from now to get accurate date
    t = 1.day.from_now.strftime("%B %e, %Y")
    mail to: @subscriber.email,
         subject: "Phez Top Posts for #{t}"
  end

  def newsletter_confirmation(newsletter_subscriber)
    @subscriber = newsletter_subscriber
    mail to: @subscriber.email,
         subject: "[Phez] Please confirm your email address"
  end

end
