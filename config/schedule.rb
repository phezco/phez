set :output, "/home/ubuntu/cron.log"

every 5.minutes do
  runner "Ranker.rank!"
end

every 1.day, :at => '1:10 am' do
  rake "phez:premium_check"
end

every 1.day, :at => '1:05 am' do
  command "backup perform --trigger phez_backup"
end

every :sunday, :at => '7pm' do
  runner "NewsletterSubscirber.send_newsletter!"
end

every :tuesday, :at => '7pm' do
  runner "NewsletterSubscirber.send_newsletter!"
end

every :thursday, :at => '7pm' do
  runner "NewsletterSubscirber.send_newsletter!"
end
