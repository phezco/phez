set :output, "/home/ubuntu/cron.log"

every 5.minutes do
  runner "Ranker.rank!"
end

every 1.day, at: '1:10 am' do
  rake "phez:premium_check"
end

every 1.day, at: '1:05 am' do
  command "backup perform --trigger phez_backup"
end

every :monday, at: '6pm' do
  runner "NewsletterSubscriber.send_newsletter!"
end

every :wednesday, at: '6pm' do
  runner "NewsletterSubscriber.send_newsletter!"
end

every :friday, at: '6pm' do
  runner "NewsletterSubscirber.send_newsletter!"
end
