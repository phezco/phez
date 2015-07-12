set :output, "/home/ubuntu/cron.log"

every 5.minutes do
  runner "Ranker.rank!"
end
